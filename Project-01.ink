/*
    Project 01
    
    Requirements (for 15 base points)
    - Create an interactive fiction story with at least 8 knots 
    - Create at least one major choice that the player can make
    - Reflect that choice back to the player
    - Include at least one loop
    
    To get a full 20 points, expand upon the game in the following ways
    [+2] Include more than eight passages
    [+1] Allow the player to pick up items and change the state of the game if certain items are in the inventory. Acknowledge if a player does or does not have a certain item
    [+1] Give the player statistics, and allow them to upgrade once or twice. Gate certain options based on statistics (high or low. Maybe a weak person can only do things a strong person can't, and vice versa)
    [+1] Keep track of visited passages and only display the description when visiting for the first time (or requested)
    
    Make sure to list the items you changed for points in the Readme.md. I cannot guess your intentions!

*/

// Player Stats
VAR pName = ""
VAR pLvl = 1
VAR pExp = 0
VAR pHp = 100
VAR pDmg = 10

// Weapon 1 Stats
VAR w1Name = "Wooden Stick"
VAR w1Hp = 5
VAR w1Dmg = 5

// Weapon 2 Stats
VAR w2Name = ""
VAR w2Hp = 5
VAR w2Dmg = 0

// Enemy Stats
VAR eName = ""
VAR eHp = 50
VAR eDmg = 10

-> intro

== intro ==
    "Welcome, brave adventurer! Remind me, what was your name?"
    + "My name is[..."]--"
-> randomName

== randomName ==
    ~ pName = "{~Steve|Bob|Jeff|Kevin|Ava|Kate|Karen|Emily}"
    "Wait, I remember your name! You're {pName}!"
    + "What?["] No, that's not my name!"
-> toBattle

== toBattle ==
    "Good luck, {~young|fair|valiant} {pName}! Take this stick I found. It will aid you in battle. However, you must be careful, because this stick will surely brake after it is used several times. Remember: a broken weapon has a chance to deal no damage at all!"
    + ["Battle!?"]
-> battleIntro

== battleIntro ==
    // "{\ |Strong|Powerful|Legendary|Otherworldly|Void|Light|Eternal|Godly|Infinetismal|Imaginary|Dream|Awakening|Renewed|Enlightened|All-seeing|Multiversal|Final} " +
    ~ eName = "{&Slime|Skeleton|Zombie|Goblin|Vampire|Troll|Gorgon|Lesser Demon|Orc|Large Slime|Phantom|Demon|Dragon}"
    ~ eHp = ((pLvl - 1) * 100) + pExp / pLvl + 30
    ~ eDmg = pLvl * 10
    An enemy {eName} appears!
-> enemyAttack

== enemyAttack ==
    {~The {eName} attacks! -> playerHit|The {eName} attacks and misses. Now's your chance!}
-> playerAttack

== playerHit ==
    ~ pHp = pHp - eDmg
    Ouch! {pName} took {eDmg} points of damage.
    {pHp <= 0:{pName} died. :(<br>Better luck next time. -> END}
-> playerAttack

== playerAttack ==
    {pName}'s stats:<br>> Lvl: {pLvl}<br>> Exp: {pExp} / {pLvl * 100}<br>> Hp: {pHp}<br>> Dmg: {pDmg}
    {eName}'s stats:<br>> Hp: {eHp}<br>> Dmg: {eDmg}
    + [Attack with {w1Name}<br>(+{w1Dmg} dmg, {pDmg+w1Dmg} total)] -> useWeapon1
    + {w2Name != ""} [Attack with {w2Name}<br>(+{w2Dmg} dmg, {pDmg+w2Dmg} total)] -> useWeapon2
-> DONE

== useWeapon1 ==
    {
        - w1Hp > 0 or RANDOM(0, 1) == 1:
        ~ eHp = eHp - (w1Dmg + pDmg)
        You dealt {w1Dmg + pDmg} points of damage to the {eName}!
        - else:
        Your attack failed because your weapon is broken.
        -> enemyAttack
    }
    
    ~ w1Hp = w1Hp - 1
    {
        - w1Hp == 0:
        Your {w1Name} broke!
        ~ w1Name = "Broken " + w1Name
    }
-> enemyHit

== useWeapon2 ==
    {
        - w2Hp > 0 or RANDOM(0, 1) == 1:
        ~ eHp = eHp - (w2Dmg + pDmg)
        You dealt {w2Dmg + pDmg} points of damage to the {eName}!
        - else:
        Your attack failed because your weapon is broken.
        -> enemyAttack
    }
    
    ~ w2Hp = w2Hp - 1
    {
        - w2Hp == 0:
        Your {w2Name} broke!
        ~ w2Name = "Broken " + w2Name
    }
-> enemyHit

== enemyHit ==
    {
        - eHp <= 0:
        The {eName} collapses in defeat! -> enemyDefeat
    }
-> enemyAttack

== enemyDefeat ==
    ~ pExp = pExp + eDmg + RANDOM(3, 5) * 10
    { pExp >= pLvl * 100:
        -> levelUp
    }
    { eName != "Slime" and (RANDOM(0, 1) == 1 or w2Name == ""):
        -> weaponCollect
    }
-> battleIntro

== weaponCollect ==
    ~ temp w3Name = "{&Club|Hammer|Hatchet|Knife|Spear|Axe|Sword|Mace|Halberd|Katana|Glaive|Trident|Cutlass|}"
    ~ temp w3Dmg = RANDOM(5, 30) + (pLvl - 1) * 10
    
    You found a {w3Name} (+{w3Dmg} dmg)!
    + {w2Name == ""} [Take {w3Name}]
        ~ w2Name = w3Name
        ~ w2Dmg = w3Dmg
        -> battleIntro
    + {w2Name != ""} [Drop {w1Name} (+{w1Dmg} dmg) and take {w3Name}]
        ~ w1Name = w3Name
        ~ w1Dmg = w3Dmg
        ~ w1Hp = 5
        -> battleIntro
    + {w2Name != ""} [Drop {w2Name} (+{w2Dmg} dmg) and take {w3Name}]
        ~ w2Name = w3Name
        ~ w2Dmg = w3Dmg
        ~ w1Hp = 5
        -> battleIntro
-> DONE

== levelUp ==
    ~ pLvl = pLvl + 1
    ~ pExp = pExp - 100
    You leveled up to level {pLvl}!
    + [Increase base damage by 20]Base damage increased by 20!
        ~ pDmg = pDmg + 20
        -> enemyDefeat
    + [Increase health by {pLvl * 50 + 50}]Health increased by {pLvl * 50 + 50}!
        ~ pHp = pHp + pLvl * 50 + 50
        -> enemyDefeat
-> DONE




