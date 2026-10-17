#pragma once

class CActiveMonster;
class CEffectScriptMan;
class CMonsterMan;
class CScene;

#ifdef PORT
/** Dungeon singletons that must survive floor map loads on `BuffStageMain`. */
CActiveMonster   *PortDungeonMonsterPool();
CEffectScriptMan *PortDungeonFxScriptMan();
CMonsterMan      *PortDungeonMonsterMan();
#endif

void PortSetDungeonMonsterPool(CActiveMonster *pool);
void PortReconnectDungeonMonsterSlots(CScene *scene);
