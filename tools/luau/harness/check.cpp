// luau-check strictly type-checks Luau scripts with the api/*.d.luau declaration files loaded.
// Usage: luau-check <scripts_root> <file.luau>...
// Files are named relative to scripts_root, or absolute. Exit 0 when clean, 1 on type or lint diagnostics, 2 when a declaration file fails to load.
#include "Luau/BuiltinDefinitions.h"
#include "Luau/Config.h"
#include "Luau/ConfigResolver.h"
#include "Luau/Error.h"
#include "Luau/FileResolver.h"
#include "Luau/Frontend.h"
#include "Luau/TypeArena.h"

#include "Luau/Flags.h"

#include <algorithm>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

namespace fs = std::filesystem;

namespace
{

std::optional<std::string> read_file(const fs::path& path)
{
    std::ifstream file(path, std::ios::binary);
    if (!file)
        return std::nullopt;
    std::ostringstream contents;
    contents << file.rdbuf();
    return contents.str();
}

// Normalised absolute path with forward slashes, used as the module name.
std::string module_name_for(const fs::path& path)
{
    return fs::absolute(path).lexically_normal().generic_string();
}

// Every module is checked in strict mode; the files also carry --!strict.
struct StrictConfigResolver : Luau::ConfigResolver
{
    StrictConfigResolver()
    {
        config.mode = Luau::Mode::Strict;
    }

    const Luau::Config& getConfig(const Luau::ModuleName&, const Luau::TypeCheckLimits&) const override
    {
        return config;
    }

    Luau::Config config;
};

// Resolves require("@lib/<x>") to <scripts_root>/lib/<x>.luau and relative "./x" or "../x" requires against the requiring file.
struct ScriptFileResolver : Luau::FileResolver
{
    explicit ScriptFileResolver(fs::path root)
        : scripts_root(std::move(root))
    {
    }

    std::optional<Luau::SourceCode> readSource(const Luau::ModuleName& name) override
    {
        std::optional<std::string> source = read_file(name);
        if (!source)
            return std::nullopt;
        return Luau::SourceCode{*source, Luau::SourceCode::Module};
    }

    std::optional<Luau::ModuleInfo> resolveModule(const Luau::ModuleInfo* context, Luau::AstExpr* expr, const Luau::TypeCheckLimits&) override
    {
        Luau::AstExprConstantString* constant = expr->as<Luau::AstExprConstantString>();
        if (!constant)
            return std::nullopt;

        std::string path(constant->value.data, constant->value.size);
        fs::path target;
        if (path.rfind("@lib/", 0) == 0)
            target = scripts_root / "lib" / (path.substr(5) + ".luau");
        else if (path.rfind("./", 0) == 0 || path.rfind("../", 0) == 0)
            target = fs::path(context->name).parent_path() / (path + ".luau");
        else
            return std::nullopt;

        target = fs::absolute(target).lexically_normal();
        if (!fs::is_regular_file(target))
            return std::nullopt;
        return Luau::ModuleInfo{target.generic_string()};
    }

    std::string getHumanReadableModuleName(const Luau::ModuleName& name) const override
    {
        std::error_code ec;
        fs::path relative = fs::path(name).lexically_relative(scripts_root);
        if (ec || relative.empty() || *relative.begin() == "..")
            return name;
        return relative.generic_string();
    }

    fs::path scripts_root;
};

void print_diagnostic(const std::string& file, const Luau::Location& location, const std::string& message)
{
    std::printf("%s:%d:%d: %s\n", file.c_str(), location.begin.line + 1, location.begin.column + 1, message.c_str());
}

} // namespace

// Mirrors the luau-analyze 0.740 setup: all Luau fast flags enabled, builtin globals registered, then declaration files loaded.
int main(int argc, char** argv)
{
    if (argc < 3)
    {
        std::fprintf(stderr, "usage: %s <scripts_root> <file.luau>...\n", argv[0]);
        return 2;
    }

    setLuauFlagsDefault();

    fs::path scripts_root = fs::absolute(argv[1]).lexically_normal();

    Luau::FrontendOptions frontend_options;
    frontend_options.runLintChecks = true;

    ScriptFileResolver file_resolver(scripts_root);
    StrictConfigResolver config_resolver;
    Luau::Frontend frontend(Luau::SolverMode::New, &file_resolver, &config_resolver, frontend_options);

    Luau::registerBuiltinGlobals(frontend, frontend.globals);

    std::vector<fs::path> definitions;
    for (const fs::directory_entry& entry : fs::directory_iterator(scripts_root / "api"))
    {
        const std::string filename = entry.path().filename().string();
        if (entry.is_regular_file() && filename.size() > 7 && filename.compare(filename.size() - 7, 7, ".d.luau") == 0)
            definitions.push_back(entry.path());
    }
    // types.d.luau declares the aliases the other declaration files use, so it loads first.
    std::sort(
        definitions.begin(),
        definitions.end(),
        [](const fs::path& a, const fs::path& b)
        {
            bool a_types = a.filename() == "types.d.luau";
            bool b_types = b.filename() == "types.d.luau";
            if (a_types != b_types)
                return a_types;
            return a < b;
        }
    );

    for (const fs::path& definition : definitions)
    {
        std::optional<std::string> source = read_file(definition);
        if (!source)
        {
            std::fprintf(stderr, "cannot read definition file %s\n", definition.generic_string().c_str());
            return 2;
        }

        std::string name = module_name_for(definition);
        Luau::LoadDefinitionFileResult result =
            frontend.loadDefinitionFile(frontend.globals, frontend.globals.globalScope, *source, name, /*captureComments*/ false);
        if (!result.success)
        {
            for (const Luau::ParseError& error : result.parseResult.errors)
                print_diagnostic(name, error.getLocation(), error.getMessage());
            if (result.module)
            {
                for (const Luau::TypeError& error : result.module->errors)
                    print_diagnostic(name, error.location, Luau::toString(error));
            }
            std::fprintf(stderr, "failed to load definition file %s\n", name.c_str());
            return 2;
        }
    }

    Luau::freeze(frontend.globals.globalTypes);

    std::vector<Luau::ModuleName> queued;
    int failed = 0;
    for (int i = 2; i < argc; ++i)
    {
        fs::path path = argv[i];
        if (!path.is_absolute())
            path = scripts_root / path;
        if (!fs::is_regular_file(path))
        {
            std::fprintf(stderr, "Error opening %s\n", argv[i]);
            ++failed;
            continue;
        }
        queued.push_back(module_name_for(path));
    }

    frontend.queueModuleCheck(queued);
    std::vector<Luau::ModuleName> checked = frontend.checkQueuedModules();

    for (const Luau::ModuleName& name : checked)
    {
        std::optional<Luau::CheckResult> result = frontend.getCheckResult(name, false);
        if (!result)
        {
            std::fprintf(stderr, "Failed to find result for %s\n", name.c_str());
            ++failed;
            continue;
        }

        std::string display = file_resolver.getHumanReadableModuleName(name);
        for (const Luau::TypeError& error : result->errors)
        {
            print_diagnostic(display, error.location, Luau::toString(error, Luau::TypeErrorToStringOptions{&file_resolver}));
            ++failed;
        }
        for (const Luau::LintWarning& warning : result->lintResult.errors)
        {
            print_diagnostic(display, warning.location, std::string(Luau::LintWarning::getName(warning.code)) + ": " + warning.text);
            ++failed;
        }
        for (const Luau::LintWarning& warning : result->lintResult.warnings)
        {
            print_diagnostic(display, warning.location, std::string(Luau::LintWarning::getName(warning.code)) + ": " + warning.text);
            ++failed;
        }
    }

    return failed == 0 ? 0 : 1;
}
