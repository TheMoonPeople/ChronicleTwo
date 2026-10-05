#include "common.h"

typedef int u128_cv __attribute__((mode(TI)));

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0ApplyMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0MulMatrix);



void sceVu0OuterProduct(float *d, float *a, float *b) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "lqc2 $vf5,0(%2)\n"
                     "vopmula.xyz ACC,vf4,vf5\n"
                     "vopmsub.xyz vf6,vf5,vf4\n"
                     "vsub.w $vf6,$vf6,$vf6\n"
                     "sqc2 $vf6,0(%0)\n"
                     :
                     : "r"(d), "r"(a), "r"(b)
                     : "memory");
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0InnerProduct);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0Normalize);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0TransposeMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0InversMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0DivVector);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0DivVectorXYZ);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0InterVector);

void sceVu0AddVector(float *d, float *a, float *b) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "lqc2 $vf5,0(%2)\n"
                     "vadd.xyzw $vf6,$vf4,$vf5\n"
                     "sqc2 $vf6,0(%0)\n"
                     :
                     : "r"(d), "r"(a), "r"(b)
                     : "memory");
}

void sceVu0SubVector(float *d, float *a, float *b) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "lqc2 $vf5,0(%2)\n"
                     "vsub.xyzw $vf6,$vf4,$vf5\n"
                     "sqc2 $vf6,0(%0)\n"
                     :
                     : "r"(d), "r"(a), "r"(b)
                     : "memory");
}

void sceVu0MulVector(float *d, float *a, float *b) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "lqc2 $vf5,0(%2)\n"
                     "vmul.xyzw $vf6,$vf4,$vf5\n"
                     "sqc2 $vf6,0(%0)\n"
                     :
                     : "r"(d), "r"(a), "r"(b)
                     : "memory");
}

void sceVu0ScaleVector(float *d, float *a, float x) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "mfc1 $8,%2\n"
                     "qmtc2.ni $8,$vf5\n"
                     "vmulx.xyzw $vf6,$vf4,$vf5x\n"
                     "sqc2 $vf6,0(%0)\n"
                     :
                     : "r"(d), "r"(a), "f"(x)
                     : "$8", "memory");
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0TransMatrix);

void sceVu0CopyVector(u128_cv *d, u128_cv *s) {
    register u128_cv t __asm__("$6");
    t = *s;
    *d = t;
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0CopyMatrix);

void sceVu0FTOI4Vector(float *d, float *a) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "vftoi4.xyzw $vf5,$vf4\n"
                     "sqc2 $vf5,0(%0)\n"
                     :
                     : "r"(d), "r"(a)
                     : "memory");
}

void sceVu0FTOI0Vector(float *d, float *a) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "vftoi0.xyzw $vf5,$vf4\n"
                     "sqc2 $vf5,0(%0)\n"
                     :
                     : "r"(d), "r"(a)
                     : "memory");
}

void sceVu0ITOF4Vector(float *d, float *a) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "vitof4.xyzw $vf5,$vf4\n"
                     "sqc2 $vf5,0(%0)\n"
                     :
                     : "r"(d), "r"(a)
                     : "memory");
}

void sceVu0ITOF0Vector(float *d, float *a) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "vitof0.xyzw $vf5,$vf4\n"
                     "sqc2 $vf5,0(%0)\n"
                     :
                     : "r"(d), "r"(a)
                     : "memory");
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0UnitMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", _sceVu0ecossin);





INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0RotMatrixZ);







INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0RotMatrixX);







INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0RotMatrixY);







INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0RotMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0ClampVector);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0CameraMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0NormalLightMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0LightColorMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0ViewScreenMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0DropShadowMatrix);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0RotTransPersN);





INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0RotTransPers);



void sceVu0CopyVectorXYZ(float *d, float *s) {
    d[0] = s[0];
    d[1] = s[1];
    d[2] = s[2];
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0InterVectorXYZ);

void sceVu0ScaleVectorXYZ(float *d, float *a, float x) {
    __asm__ volatile("lqc2 $vf4,0(%1)\n"
                     "mfc1 $8,%2\n"
                     "qmtc2.ni $8,$vf5\n"
                     "vmulx.xyz $vf4,$vf4,$vf5x\n"
                     "sqc2 $vf4,0(%0)\n"
                     :
                     : "r"(d), "r"(a), "f"(x)
                     : "$8", "memory");
}

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0ClipScreen);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0ClipScreen3);

INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVu0ClipAll);





INCLUDE_ASM("ps2/asm/pal/nonmatchings/lib/sce/libvu0", sceVpu0Reset);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libvu0", S5432__DATA);

INCLUDE_RODATA("ps2/asm/pal/nonmatchings/lib/sce/libvu0", init_vif_regs_126__DATA);
