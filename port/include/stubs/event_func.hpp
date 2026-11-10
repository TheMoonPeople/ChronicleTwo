#pragma once

// Retail binds event_func's VectMatMul under the __2 name; eventedit's copy keeps the plain one.
#define VectMatMul VectMatMul__2

class ClsMes;

// The native fishing-tournament external opens its records window through the event message lookup.
ClsMes *GetMes(int id) asm("EventFunc_GetMes");

// The monster slot limits of the current floor (port/src/monster.cpp).
int PortMonsterLatchLimits();
int PortMonsterActiveLimit();
