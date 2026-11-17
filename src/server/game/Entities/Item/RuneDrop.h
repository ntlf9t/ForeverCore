#ifndef TRINITYCORE_RUNEDROP_H
#define TRINITYCORE_RUNEDROP_H

class Creature;
class Player;

namespace RuneDrop
{
    // 击杀怪物后按等级/稀有度概率直接给战利品（符文）
    void OnCreatureKilled(Creature* creature, Player* looter);
}

#endif // TRINITYCORE_RUNEDROP_H
