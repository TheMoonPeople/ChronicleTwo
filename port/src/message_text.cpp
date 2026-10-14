#include "common.h"

#include <cstdint>
#include <map>
#include <string_view>
#include <tuple>
#include <vector>

#include "nd_meswin.hpp"

// The PAL disc's menu and system messages describe PS2 memory cards, their slots and the console.
// The PC port keeps saves, the photo album and Extras data in folders, so the messages that
// mention them are replaced here in every PAL language, as text in the message's own encoding.
// The disc files are recognised by their header words; any other message file is left as it is.

namespace {

enum class MesFile { kAllMenu, kSysMes };

struct KnownFile {
    MesFile       file;
    int           language;
    std::uint16_t count;
    std::uint16_t word1;
};

// Header words of menu/<language>/*.pac:allmenu.mes and meswin/sysmes_<language>.mes on the PAL disc.
constexpr KnownFile kKnownFiles[] = {
    {MesFile::kAllMenu, 1, 933, 14870}, {MesFile::kAllMenu, 2, 934, 16394}, {MesFile::kAllMenu, 3, 933, 11090},
    {MesFile::kAllMenu, 4, 934, 17338}, {MesFile::kAllMenu, 5, 934, 20008}, {MesFile::kSysMes, 1, 360, 27192},
    {MesFile::kSysMes, 2, 360, 28058},  {MesFile::kSysMes, 3, 360, 24658},  {MesFile::kSysMes, 4, 360, 27594},
    {MesFile::kSysMes, 5, 360, 27654},
};

struct Replacement {
    MesFile          file;
    int              language;
    int              id;
    std::string_view text;
};

// UTF-8. "\n" is a line break, "{XXXX}" a raw message code ({FBFA} the slot number, {FBF9} the
// size in KB), and "{TAIL}" the original message's last line, which holds the button prompts.
constexpr Replacement kReplacements[] = {
    // English
    {MesFile::kAllMenu, 1, 670, "View Album?"},
    {MesFile::kAllMenu, 1, 671, "No Album data was found."},
    {MesFile::kAllMenu, 1, 673, "Save current Album?"},
    {MesFile::kAllMenu, 1, 678, "No Album data was found\nin this Album.\nCreate a new Album?"},
    {MesFile::kAllMenu, 1, 679, "Insufficient space\nfor album data (490KB required)."},
    {MesFile::kAllMenu, 1, 684, "Select an Album.\n   Album 1\n   Album 2"},
    {MesFile::kAllMenu, 1, 687, "Saving the Album..."},
    {MesFile::kAllMenu, 1, 689,
     "No Album data was found\nin this Album.\n490KB of free space\nis needed for Album data.\nCreate an Album?"},
    {MesFile::kAllMenu, 1, 691, "This Album is not set up.\nSet it up now?"},
    {MesFile::kAllMenu, 1, 692, "Select where to\nsave the Album data.\n   Album 1\n   Album 2"},
    {MesFile::kAllMenu, 1, 693, "No Album data was found\nin this Album."},
    {MesFile::kAllMenu, 1, 3000, "Use which slot?\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 1, 3001, "Slot {FBFA} is not available."},
    {MesFile::kAllMenu, 1, 3002, "Failed to read slot {FBFA}."},
    {MesFile::kAllMenu, 1, 3003, "Now reading..."},
    {MesFile::kAllMenu, 1, 3004, "Not enough free space in slot {FBFA}.\nAt least {FBF9}KB is necessary\nfor a new file."},
    {MesFile::kAllMenu, 1, 3005, "Failed to read slot {FBFA}."},
    {MesFile::kAllMenu, 1, 3007, "Saving data...\nPlease do not close the game."},
    {MesFile::kAllMenu, 1, 3010, "Slot {FBFA} is not set up.\nSet it up and create a new file?"},
    {MesFile::kAllMenu, 1, 3013, "Reading data..."},
    {MesFile::kAllMenu, 1, 3041, "Loading data...\nPlease do not close the game."},
    {MesFile::kAllMenu, 1, 3043, "Slot {FBFA} contains\nno Dark Chronicle data."},
    {MesFile::kAllMenu, 1, 3044, "Slot {FBFA} is not set up.\nSet it up and create a new file?"},
    {MesFile::kAllMenu, 1, 3046, "There is not enough free space."},
    {MesFile::kAllMenu, 1, 3047, "No slot is available."},
    {MesFile::kAllMenu, 1, 3048, "Setting up slot {FBFA}...\nPlease do not close the game."},
    {MesFile::kAllMenu, 1, 3050, "The slot is not set up."},
    {MesFile::kAllMenu, 1, 3051, "The slot is not set up.\nSet it up?"},
    {MesFile::kAllMenu, 1, 3052, "Set up the slot?"},
    {MesFile::kAllMenu, 1, 3053, "Slot {FBFA} is not set up.\nPlease choose a slot containing\na Dark Chronicle save file."},
    {MesFile::kAllMenu, 1, 3060, "Clear the slot?"},
    {MesFile::kAllMenu, 1, 3070, "Save progress?"},
    {MesFile::kAllMenu, 1, 3100, "Select a slot."},
    {MesFile::kAllMenu, 1, 3103, "Slot 1"},
    {MesFile::kAllMenu, 1, 3104, "Slot 2"},
    {MesFile::kAllMenu, 1, 3150, "Saves Extras data.\nPlease choose...\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 1, 3151, "Loads Extras data.\nPlease choose...\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 1, 3152,
     "Not enough free space in slot {FBFA}.\nAt least {FBF9}KB is necessary\nfor a new Extras file."},
    {MesFile::kAllMenu, 1, 3153,
     "No Extras data was found\nin this slot.\n{FBF9}KB of free space is needed to\ncreate a new Extras "
     "file.\nCreate a new Extras file now?"},
    {MesFile::kAllMenu, 1, 3154, "Extras data in slot {FBFA}\nmay be corrupted.\nPlease delete it from the save folder."},
    {MesFile::kAllMenu, 1, 3158, "This will overwrite Extras data\nin slot {FBFA}.\nSave anyway?"},
    {MesFile::kAllMenu, 1, 3159, "Load Extras data from slot {FBFA}?"},
    {MesFile::kAllMenu, 1, 3161, "No Extras data was found\nin this slot.\nBegin Extras anyway?"},
    {MesFile::kAllMenu, 1, 3162, "No Extras data was found\nin this slot."},
    {MesFile::kAllMenu, 1, 3164, "Saving..."},
    {MesFile::kAllMenu, 1, 3165, "Loading..."},
    {MesFile::kSysMes, 1, 100,
     "Game data cannot be saved.\nAt least 502KB of free space is required\nto save game data. Continue without "
     "saving?{TAIL}"},
    {MesFile::kSysMes, 1, 101,
     "There is insufficient space to save.\nAt least 502KB is necessary to\nsave game data. Continue anyway?{TAIL}"},
    {MesFile::kSysMes, 1, 102, "Loading..."},

    // French
    {MesFile::kAllMenu, 2, 670, "Voir album ?"},
    {MesFile::kAllMenu, 2, 671, "Aucune donnée Album."},
    {MesFile::kAllMenu, 2, 673, "Sauvegarder l'album ?"},
    {MesFile::kAllMenu, 2, 678, "Aucune donnée Album\ndans cet album.\nCréer un nouvel album ?"},
    {MesFile::kAllMenu, 2, 679, "490 KB d'espace libre\nsont requis pour créer un album."},
    {MesFile::kAllMenu, 2, 684, "Choisis un album.\n   Album Nº1\n   Album Nº2"},
    {MesFile::kAllMenu, 2, 687, "Sauvegarde de l'album..."},
    {MesFile::kAllMenu, 2, 689,
     "Pas de données Album\ndans cet album.\n490 KB d'espace libre\nsont requis pour les données Album.\nCréer un "
     "album ?"},
    {MesFile::kAllMenu, 2, 691, "Cet album n'est pas prêt.\nLe préparer ?"},
    {MesFile::kAllMenu, 2, 692, "Choisis où sauvegarder\nl'album.\n   Album Nº1\n   Album Nº2"},
    {MesFile::kAllMenu, 2, 693, "Aucune donnée Album\ndans cet album."},
    {MesFile::kAllMenu, 2, 3000, "Utiliser quel emplacement ?\n   Emplacement Nº1\n   Emplacement Nº2"},
    {MesFile::kAllMenu, 2, 3001, "L'emplacement {FBFA} n'est pas disponible."},
    {MesFile::kAllMenu, 2, 3002, "Échec de lecture de l'emplacement {FBFA}."},
    {MesFile::kAllMenu, 2, 3003, "Lecture en cours..."},
    {MesFile::kAllMenu, 2, 3004, "Espace libre insuffisant.\nMinimum {FBF9} KB requis\npour créer un nouveau fichier."},
    {MesFile::kAllMenu, 2, 3005, "Échec de lecture de l'emplacement {FBFA}."},
    {MesFile::kAllMenu, 2, 3007, "Sauvegarde des données...\nNe pas quitter le jeu."},
    {MesFile::kAllMenu, 2, 3010, "L'emplacement {FBFA} n'est pas prêt.\nLe préparer et créer nouveau fichier ?"},
    {MesFile::kAllMenu, 2, 3013, "Lecture des données..."},
    {MesFile::kAllMenu, 2, 3041, "Chargement des données...\nNe pas quitter le jeu."},
    {MesFile::kAllMenu, 2, 3043, "Pas de données du jeu Dark Chronicle\ndans l'emplacement {FBFA}."},
    {MesFile::kAllMenu, 2, 3044, "L'emplacement {FBFA} n'est pas prêt.\nLe préparer et créer nouveau fichier ?"},
    {MesFile::kAllMenu, 2, 3046, "Pas d'espace libre."},
    {MesFile::kAllMenu, 2, 3047, "Aucun emplacement disponible."},
    {MesFile::kAllMenu, 2, 3048, "Préparation de l'emplacement {FBFA}...\nNe pas quitter le jeu."},
    {MesFile::kAllMenu, 2, 3050, "L'emplacement n'est pas prêt."},
    {MesFile::kAllMenu, 2, 3051, "L'emplacement n'est pas prêt.\nLe préparer ?"},
    {MesFile::kAllMenu, 2, 3052, "Préparer l'emplacement ?"},
    {MesFile::kAllMenu, 2, 3053,
     "L'emplacement {FBFA} n'est pas prêt.\nChoisis un emplacement contenant\ndes données du jeu Dark Chronicle."},
    {MesFile::kAllMenu, 2, 3060, "Vider l'emplacement ?"},
    {MesFile::kAllMenu, 2, 3070, "Sauvegarder ?"},
    {MesFile::kAllMenu, 2, 3100, "Choisis un emplacement."},
    {MesFile::kAllMenu, 2, 3103, "Emplacement Nº1"},
    {MesFile::kAllMenu, 2, 3104, "Emplacement Nº2"},
    {MesFile::kAllMenu, 2, 3150,
     "Sauvegarde les données Bonus.\nChoisis l'emplacement :\n   Emplacement Nº1\n   Emplacement Nº2"},
    {MesFile::kAllMenu, 2, 3151, "Charge les données Bonus.\nChoisis l'emplacement :\n   Emplacement Nº1\n   Emplacement Nº2"},
    {MesFile::kAllMenu, 2, 3152, "Espace libre insuffisant.\nMinimum {FBF9} KB requis\npour un nouveau fichier Bonus."},
    {MesFile::kAllMenu, 2, 3153,
     "Aucune donnée Bonus dans\ncet emplacement.\n{FBF9} KB d'espace libre\nsont requis pour créer\nun nouveau "
     "fichier Bonus.\nCréer un nouveau fichier Bonus ?"},
    {MesFile::kAllMenu, 2, 3154,
     "Les données Bonus sont peut-être\ncorrompues. Efface-les depuis\nle dossier de sauvegarde."},
    {MesFile::kAllMenu, 2, 3158,
     "Les données Bonus de l'emplacement {FBFA}\nseront écrasées. Sauvegarder quand même ?"},
    {MesFile::kAllMenu, 2, 3159, "Charger les données Bonus ?"},
    {MesFile::kAllMenu, 2, 3161, "Aucune donnée Bonus\ndans cet emplacement.\nLancer Bonus quand même ?"},
    {MesFile::kAllMenu, 2, 3162, "Aucune donnée Bonus\ndans cet emplacement."},
    {MesFile::kAllMenu, 2, 3164, "Sauvegarde..."},
    {MesFile::kAllMenu, 2, 3165, "Chargement..."},
    {MesFile::kSysMes, 2, 100,
     "Impossible de sauvegarder les données.\n502 KB d'espace libre minimum sont requis\npour sauvegarder les "
     "données.\nPoursuivre sans sauvegarder ?{TAIL}"},
    {MesFile::kSysMes, 2, 101,
     "Espace libre insuffisant pour sauvegarder.\n502 KB minimum sont nécessaires pour\nsauvegarder les données. "
     "Continuer ?{TAIL}"},
    {MesFile::kSysMes, 2, 102, "Chargement..."},

    // German
    {MesFile::kAllMenu, 3, 670, "Album öffnen?"},
    {MesFile::kAllMenu, 3, 671, "Keine Album-Daten gefunden."},
    {MesFile::kAllMenu, 3, 673, "Akt. Album speichern?"},
    {MesFile::kAllMenu, 3, 678, "Keine Album-Daten in\ndiesem Album gefunden.\nNeues Album erstellen?"},
    {MesFile::kAllMenu, 3, 679, "490 KB freier Speicherplatz\nerforderlich, um Album zu erstellen."},
    {MesFile::kAllMenu, 3, 684, "Album wählen.\n  Album 1\n  Album 2"},
    {MesFile::kAllMenu, 3, 687, "Album wird gespeichert ..."},
    {MesFile::kAllMenu, 3, 689,
     "In diesem Album\nkeine Album-Daten gefunden.\n490 KB freier Speicherplatz\nerforderlich für Album-Daten.\nAlbum "
     "erstellen?"},
    {MesFile::kAllMenu, 3, 691, "Dieses Album ist nicht bereit.\nJetzt vorbereiten?"},
    {MesFile::kAllMenu, 3, 692, "Speicherort für die\nAlbum-Daten wählen.\n   Album 1\n   Album 2"},
    {MesFile::kAllMenu, 3, 693, "In diesem Album keine\nAlbum-Daten gefunden."},
    {MesFile::kAllMenu, 3, 3000, "Welchen Slot verwenden?\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 3, 3001, "Slot {FBFA} ist nicht verfügbar."},
    {MesFile::kAllMenu, 3, 3002, "Lesen von Slot {FBFA} gescheitert."},
    {MesFile::kAllMenu, 3, 3003, "Liest ..."},
    {MesFile::kAllMenu, 3, 3004, "Nicht genug Platz in Slot {FBFA}.\nMind. {FBF9} KB für neue\nDatei benötigt."},
    {MesFile::kAllMenu, 3, 3005, "Lesen von Slot {FBFA} gescheitert."},
    {MesFile::kAllMenu, 3, 3007, "Speichert ...\nSpiel bitte nicht beenden."},
    {MesFile::kAllMenu, 3, 3010, "Slot {FBFA} ist nicht bereit.\nVorbereiten und Datei erstellen?"},
    {MesFile::kAllMenu, 3, 3013, "Liest Daten ..."},
    {MesFile::kAllMenu, 3, 3041, "Lädt Daten ...\nSpiel bitte nicht beenden."},
    {MesFile::kAllMenu, 3, 3043, "Slot {FBFA} enthält\nkeine \"Dark Chronicle\"-Daten."},
    {MesFile::kAllMenu, 3, 3044, "Slot {FBFA} ist nicht bereit.\nVorbereiten und Datei erstellen?"},
    {MesFile::kAllMenu, 3, 3046, "Nicht genügend freier Platz."},
    {MesFile::kAllMenu, 3, 3047, "Kein Slot verfügbar."},
    {MesFile::kAllMenu, 3, 3048, "Bereitet Slot {FBFA} vor ...\nSpiel bitte nicht beenden."},
    {MesFile::kAllMenu, 3, 3050, "Der Slot ist nicht bereit."},
    {MesFile::kAllMenu, 3, 3051, "Der Slot ist nicht bereit.\nVorbereiten?"},
    {MesFile::kAllMenu, 3, 3052, "Slot vorbereiten?"},
    {MesFile::kAllMenu, 3, 3053, "Slot {FBFA} ist nicht bereit. Bitte einen\nSlot mit 'Dark Chronicle'-Daten wählen."},
    {MesFile::kAllMenu, 3, 3060, "Slot leeren?"},
    {MesFile::kAllMenu, 3, 3070, "Spielstand speichern?"},
    {MesFile::kAllMenu, 3, 3100, "Slot wählen."},
    {MesFile::kAllMenu, 3, 3103, "Slot 1"},
    {MesFile::kAllMenu, 3, 3104, "Slot 2"},
    {MesFile::kAllMenu, 3, 3150, "Speichert Extra-Daten.\nSlot wählen.\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 3, 3151, "Lädt Extra-Daten.\nSlot wählen.\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 3, 3152, "Nicht genug Platz in Slot {FBFA}.\nMind. {FBF9} KB nötig\nfür neue Extra-Datei."},
    {MesFile::kAllMenu, 3, 3153,
     "Keine Extra-Daten in\ndiesem Slot gefunden.\n{FBF9} KB freier Speicherplatz\nnötig für neue "
     "Extra-Datei.\nExtra-Datei jetzt erstellen?"},
    {MesFile::kAllMenu, 3, 3154,
     "Extra-Daten in Slot {FBFA} sind\nu. U. beschädigt. Bitte im\nSpielstand-Ordner löschen."},
    {MesFile::kAllMenu, 3, 3158, "Extra-Daten in Slot {FBFA} werden\nüberschrieben. Trotzdem speichern?"},
    {MesFile::kAllMenu, 3, 3159, "Extra-Daten aus Slot {FBFA} laden?"},
    {MesFile::kAllMenu, 3, 3161, "Keine Extra-Daten in\ndiesem Slot gefunden.\nExtras trotzdem starten?"},
    {MesFile::kAllMenu, 3, 3162, "Keine Extra-Daten in\ndiesem Slot gefunden."},
    {MesFile::kAllMenu, 3, 3164, "Speichert ..."},
    {MesFile::kAllMenu, 3, 3165, "Lädt ..."},
    {MesFile::kSysMes, 3, 100,
     "Speichern nicht möglich. Mind. 502 KB\nfreier Speicherplatz sind zum Speichern\nerforderlich. "
     "Fortfahren,\nohne zu speichern?{TAIL}"},
    {MesFile::kSysMes, 3, 101,
     "Nicht genügend Speicherplatz.\nMind. 502 KB freier Speicherplatz\nsind zum Speichern erforderlich. Trotzdem "
     "fortfahren?{TAIL}"},
    {MesFile::kSysMes, 3, 102, "Lädt ..."},

    // Italian
    {MesFile::kAllMenu, 4, 670, "Visualizzare Album?"},
    {MesFile::kAllMenu, 4, 671, "Nessun dato Album trovato."},
    {MesFile::kAllMenu, 4, 673, "Salvare Album?"},
    {MesFile::kAllMenu, 4, 678, "Questo Album\nnon contiene dati.\nCreare un nuovo Album?"},
    {MesFile::kAllMenu, 4, 679, "Per creare un Album sono necessari\n490KB di spazio libero."},
    {MesFile::kAllMenu, 4, 684, "Seleziona un Album.\n   Album 1\n   Album 2"},
    {MesFile::kAllMenu, 4, 687, "Salvataggio Album in corso..."},
    {MesFile::kAllMenu, 4, 689,
     "Dati Album non trovati\nin questo Album.\nPer i dati Album sono necessari\n490KB di spazio libero.\nCreare un "
     "Album?"},
    {MesFile::kAllMenu, 4, 691, "Questo Album non è pronto.\nPrepararlo ora?"},
    {MesFile::kAllMenu, 4, 692, "Per salvare i dati dell'Album,\nseleziona dove salvarli.\n   Album 1\n   Album 2"},
    {MesFile::kAllMenu, 4, 693, "Questo Album\nnon contiene dati."},
    {MesFile::kAllMenu, 4, 3000, "Quale slot vuoi usare?\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 4, 3001, "Lo slot {FBFA} non è disponibile."},
    {MesFile::kAllMenu, 4, 3002, "Impossibile leggere lo slot {FBFA}."},
    {MesFile::kAllMenu, 4, 3003, "Lettura in corso..."},
    {MesFile::kAllMenu, 4, 3004,
     "Spazio libero insufficiente\nnello slot {FBFA}.\nPer un file nuovo sono necessari\nalmeno {FBF9}KB."},
    {MesFile::kAllMenu, 4, 3005, "Impossibile leggere lo slot {FBFA}."},
    {MesFile::kAllMenu, 4, 3007, "Salvataggio in corso...\nNon chiudere il gioco."},
    {MesFile::kAllMenu, 4, 3010, "Lo slot {FBFA} non è pronto.\nPrepararlo e creare un nuovo file?"},
    {MesFile::kAllMenu, 4, 3013, "Lettura dati in corso..."},
    {MesFile::kAllMenu, 4, 3041, "Caricamento dati in corso...\nNon chiudere il gioco."},
    {MesFile::kAllMenu, 4, 3043, "Lo slot {FBFA} non contiene\ndati di Dark Chronicle."},
    {MesFile::kAllMenu, 4, 3044, "Lo slot {FBFA} non è pronto.\nPrepararlo e creare un nuovo file?"},
    {MesFile::kAllMenu, 4, 3046, "Spazio libero insufficiente."},
    {MesFile::kAllMenu, 4, 3047, "Nessuno slot disponibile."},
    {MesFile::kAllMenu, 4, 3048, "Preparazione dello slot {FBFA} in corso...\nNon chiudere il gioco."},
    {MesFile::kAllMenu, 4, 3050, "Lo slot non è pronto."},
    {MesFile::kAllMenu, 4, 3051, "Lo slot non è pronto.\nPrepararlo?"},
    {MesFile::kAllMenu, 4, 3052, "Preparare lo slot?"},
    {MesFile::kAllMenu, 4, 3053,
     "Lo slot {FBFA} non è pronto.\nScegli uno slot che contenga\nun file salvato di Dark Chronicle."},
    {MesFile::kAllMenu, 4, 3060, "Svuotare lo slot?"},
    {MesFile::kAllMenu, 4, 3070, "Salvare il gioco?"},
    {MesFile::kAllMenu, 4, 3100, "Seleziona uno slot."},
    {MesFile::kAllMenu, 4, 3103, "Slot 1"},
    {MesFile::kAllMenu, 4, 3104, "Slot 2"},
    {MesFile::kAllMenu, 4, 3150, "Salva dati Extra.\nScegli.\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 4, 3151, "Carica dati Extra.\nScegli:\n   Slot 1\n   Slot 2"},
    {MesFile::kAllMenu, 4, 3152,
     "Lo slot {FBFA} non ha spazio libero sufficiente.\nPer un nuovo file Extra sono\nnecessari almeno {FBF9}KB."},
    {MesFile::kAllMenu, 4, 3153,
     "In questo slot non è\nstato trovato alcun dato Extra.\nPer creare un nuovo file Extra\nservono almeno "
     "{FBF9}KB\ndi spazio libero.\nCreare un nuovo file Extra ora?"},
    {MesFile::kAllMenu, 4, 3154,
     "I dati Extra nello slot {FBFA}\npotrebbero essere danneggiati.\nCancellali dalla cartella dei salvataggi."},
    {MesFile::kAllMenu, 4, 3158, "I dati Extra nello slot {FBFA}\nverranno sovrascritti.\nSalvare comunque?"},
    {MesFile::kAllMenu, 4, 3159, "Caricare i dati Extra dallo slot {FBFA}?"},
    {MesFile::kAllMenu, 4, 3161, "Nessun dato Extra trovato\nin questo slot.\nAvviare Extra comunque?"},
    {MesFile::kAllMenu, 4, 3162, "Nessun dato Extra trovato\nin questo slot."},
    {MesFile::kAllMenu, 4, 3164, "Salvataggio in corso..."},
    {MesFile::kAllMenu, 4, 3165, "Caricamento in corso..."},
    {MesFile::kSysMes, 4, 100,
     "Impossibile salvare. Per salvare i dati\ndi gioco occorrono almeno 502 KB\ndi spazio libero. Continuare senza "
     "salvare?{TAIL}"},
    {MesFile::kSysMes, 4, 101,
     "Spazio insufficiente per salvare.\nOccorrono almeno 502 KB per salvare\ni dati di gioco. Continuare "
     "ugualmente?{TAIL}"},
    {MesFile::kSysMes, 4, 102, "Caricamento..."},

    // Spanish
    {MesFile::kAllMenu, 5, 670, "¿Ver Álbum?"},
    {MesFile::kAllMenu, 5, 671, "No hay datos del Álbum."},
    {MesFile::kAllMenu, 5, 673, "¿Guardar el Álbum actual?"},
    {MesFile::kAllMenu, 5, 678, "No hay datos guardados\nen este Álbum.\n¿Crear un Álbum nuevo?"},
    {MesFile::kAllMenu, 5, 679, "No hay espacio suficiente\npara guardar un Álbum (490 KB)."},
    {MesFile::kAllMenu, 5, 684, "Selecciona un Álbum.\n   Álbum 1\n   Álbum 2"},
    {MesFile::kAllMenu, 5, 687, "Guardando el Álbum..."},
    {MesFile::kAllMenu, 5, 689,
     "No hay datos guardados\nen este Álbum.\nSe necesitan 490 KB de espacio\nlibre para guardar el "
     "Álbum.\n¿Guardar Álbum?"},
    {MesFile::kAllMenu, 5, 691, "Este Álbum no está preparado.\n¿Quieres prepararlo?"},
    {MesFile::kAllMenu, 5, 692, "Selecciona dónde guardar\nlos datos del Álbum:\n  Álbum 1\n  Álbum 2"},
    {MesFile::kAllMenu, 5, 693, "No hay datos guardados\nen este Álbum."},
    {MesFile::kAllMenu, 5, 3000, "¿Qué ranura quieres usar?\n  Ranura 1\n  Ranura 2"},
    {MesFile::kAllMenu, 5, 3001, "La ranura {FBFA} no está disponible."},
    {MesFile::kAllMenu, 5, 3002, "¡Error al leer la ranura {FBFA}!"},
    {MesFile::kAllMenu, 5, 3003, "Comprobando datos..."},
    {MesFile::kAllMenu, 5, 3004,
     "No hay espacio suficiente en la ranura {FBFA}.\nNecesitas al menos {FBF9} KB para guardar datos."},
    {MesFile::kAllMenu, 5, 3005, "¡Error al leer la ranura {FBFA}!"},
    {MesFile::kAllMenu, 5, 3007, "Guardando datos.\nNo cierres el juego."},
    {MesFile::kAllMenu, 5, 3010, "La ranura {FBFA} no está preparada.\n¿Quieres prepararla?"},
    {MesFile::kAllMenu, 5, 3013, "Leyendo datos..."},
    {MesFile::kAllMenu, 5, 3041, "Cargando datos.\nNo cierres el juego."},
    {MesFile::kAllMenu, 5, 3043, "No hay datos guardados de Dark Chronicle\nen la ranura {FBFA}."},
    {MesFile::kAllMenu, 5, 3044, "La ranura {FBFA} no está preparada.\n¿Quieres prepararla?"},
    {MesFile::kAllMenu, 5, 3046, "No hay espacio suficiente."},
    {MesFile::kAllMenu, 5, 3047, "No hay ninguna ranura disponible."},
    {MesFile::kAllMenu, 5, 3048, "Preparando la ranura {FBFA}.\nNo cierres el juego."},
    {MesFile::kAllMenu, 5, 3050, "La ranura no está preparada."},
    {MesFile::kAllMenu, 5, 3051, "La ranura no está preparada.\n¿Quieres prepararla?"},
    {MesFile::kAllMenu, 5, 3052, "¿Preparar la ranura?"},
    {MesFile::kAllMenu, 5, 3053,
     "La ranura {FBFA} no está preparada.\nElige una ranura con una partida\nguardada de Dark Chronicle."},
    {MesFile::kAllMenu, 5, 3060, "¿Vaciar la ranura?"},
    {MesFile::kAllMenu, 5, 3070, "¿Guardar datos?"},
    {MesFile::kAllMenu, 5, 3100, "Selecciona una ranura."},
    {MesFile::kAllMenu, 5, 3103, "Ranura 1"},
    {MesFile::kAllMenu, 5, 3104, "Ranura 2"},
    {MesFile::kAllMenu, 5, 3150, "Guarda los Extras.\nSelecciona una ranura.\n   Ranura 1\n   Ranura 2"},
    {MesFile::kAllMenu, 5, 3151, "Carga los Extras.\nSelecciona una ranura.\n   Ranura 1\n   Ranura 2"},
    {MesFile::kAllMenu, 5, 3152,
     "No hay espacio suficiente en la ranura {FBFA}.\nNecesitas al menos {FBF9} KB\npara guardar los Extras."},
    {MesFile::kAllMenu, 5, 3153,
     "No hay datos guardados de Extras\nen esta ranura.\nNecesitas {FBF9} KB de espacio libre\npara guardar nuevos "
     "Extras.\n¿Guardar los Extras ahora?"},
    {MesFile::kAllMenu, 5, 3154,
     "Los Extras de la ranura {FBFA}\npueden estar dañados.\nBórralos de la carpeta de partidas."},
    {MesFile::kAllMenu, 5, 3158, "Se sobrescribirán los Extras\nde la ranura {FBFA}.\n¿Guardar de todos modos?"},
    {MesFile::kAllMenu, 5, 3159, "¿Cargar Extras de la ranura {FBFA}?"},
    {MesFile::kAllMenu, 5, 3161, "No hay datos guardados de Extras\nen esta ranura.\n¿Comenzar Extras de todos modos?"},
    {MesFile::kAllMenu, 5, 3162, "No hay datos guardados de Extras\nen esta ranura."},
    {MesFile::kAllMenu, 5, 3164, "Guardando datos..."},
    {MesFile::kAllMenu, 5, 3165, "Cargando datos..."},
    {MesFile::kSysMes, 5, 100,
     "No se pueden guardar datos.\nSe necesitan al menos 502 KB de espacio libre.\n¿Continuar sin guardar?{TAIL}"},
    {MesFile::kSysMes, 5, 101,
     "No hay espacio suficiente para guardar.\nSe necesitan al menos 502 KB de espacio libre.\n¿Continuar de todas "
     "formas?{TAIL}"},
    {MesFile::kSysMes, 5, 102, "Cargando..."},
};

constexpr std::uint16_t kCodeNewline = 0xFF00;
constexpr std::uint16_t kCodeEnd = 0xFF01;
constexpr std::uint16_t kCodeSpace = 0xFF02;

// The retail lookup, as ClsMes::GetTextLineDataTop does it.
u16 *FindLine(short *table, int line_id) {
    if (table == NULL) {
        return NULL;
    }
    int    count = *table;
    short *entries = table + 1;
    for (int i = 0; i < count; i++) {
        if (line_id == (u16) entries[i * 2 + 1]) {
            return (u16 *) (entries + count + (u16) entries[i * 2 + 2]);
        }
    }
    return NULL;
}

const KnownFile *Identify(const short *table) {
    for (const auto &known : kKnownFiles) {
        if ((u16) table[0] == known.count && (u16) table[1] == known.word1) {
            return &known;
        }
    }
    return nullptr;
}

// Half-width glyphs follow ASCII from the space, with no backslash; Latin-1 letters use 0xFF00 + the code point.
void Append(std::vector<std::uint16_t> &out, char32_t ch) {
    if (ch == U'\n') {
        out.push_back(kCodeNewline);
    } else if (ch == U' ') {
        out.push_back(kCodeSpace);
    } else if (ch > 0x20 && ch < 0x5C) {
        out.push_back(static_cast<std::uint16_t>(ch - 0x20));
    } else if (ch > 0x5C && ch < 0x7F) {
        out.push_back(static_cast<std::uint16_t>(ch - 0x21));
    } else if (ch >= 0xA0 && ch <= 0xFF) {
        out.push_back(static_cast<std::uint16_t>(0xFF00 | ch));
    }
}

std::vector<std::uint16_t> Encode(std::string_view text, const u16 *original) {
    std::vector<std::uint16_t> out;
    for (std::size_t i = 0; i < text.size();) {
        if (text[i] == '{') {
            const auto close = text.find('}', i);
            const auto token = text.substr(i + 1, close - i - 1);
            if (token == "TAIL") {
                const u16 *tail = nullptr;
                for (const u16 *code = original; code && *code != kCodeEnd; ++code) {
                    if (*code == kCodeNewline) {
                        tail = code;
                    }
                }
                for (; tail && *tail != kCodeEnd; ++tail) {
                    out.push_back(*tail);
                }
            } else {
                std::uint16_t code = 0;
                for (char digit : token) {
                    code = static_cast<std::uint16_t>(code * 16 + (digit <= '9' ? digit - '0' : digit - 'A' + 10));
                }
                out.push_back(code);
            }
            i = close + 1;
            continue;
        }
        const auto lead = static_cast<unsigned char>(text[i]);
        char32_t   ch = lead;
        std::size_t length = 1;
        if (lead >= 0xC0 && lead < 0xE0 && i + 1 < text.size()) {
            ch = ((lead & 0x1F) << 6) | (static_cast<unsigned char>(text[i + 1]) & 0x3F);
            length = 2;
        }
        Append(out, ch);
        i += length;
    }
    out.push_back(kCodeEnd);
    return out;
}

u16 *Lookup(short *table, int line_id) {
    u16 *original = FindLine(table, line_id);
    if (table == NULL) {
        return original;
    }
    const KnownFile *known = Identify(table);
    if (!known) {
        return original;
    }
    static std::map<std::tuple<MesFile, int, int>, std::vector<std::uint16_t> > encoded;
    const auto key = std::make_tuple(known->file, known->language, line_id);
    if (auto found = encoded.find(key); found != encoded.end()) {
        return reinterpret_cast<u16 *>(found->second.data());
    }
    for (const auto &replacement : kReplacements) {
        if (replacement.file == known->file && replacement.language == known->language && replacement.id == line_id) {
            auto &codes = encoded[key] = Encode(replacement.text, original);
            return reinterpret_cast<u16 *>(codes.data());
        }
    }
    return original;
}

} // namespace

PORT_OVERRIDE u16 *ClsMes::GetTextLineDataTop(int line_id) {
    return Lookup(buff, line_id);
}

PORT_OVERRIDE u16 *ClsMes::GetTextLineDataTop_system(int line_id) {
    return Lookup(buff_system, line_id);
}
