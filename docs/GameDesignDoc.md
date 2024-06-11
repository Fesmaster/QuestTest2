# QuestTest2 Game Design Document

## Abstract

QuestTest2 is a voxel-based, open world RPG game built in the Minetest Engine. It prioritizes player choice and proactive storytelling.

QuestTest2 targets Single player for Windows and Linux on x64 machines. We do not support multiplayer, Mac, Android, or and ARM machines.

The target platforms might change depending on future developments.

Keep in mind that this is a *living* document - it should be changed and updated as elements of the game design change.

## Project

### Leadership

QuestTest2 project is owned and manged by The Fesmaster (Stephen Kelly). All change to game design (and thus, this document) should go through him.

### Goals

QuestTest2 project goals are:

- Education - The first purpose of this project is to help the more junior members of the project improve in their programming and design skills
- Research - The secondary purpose of this project is a research platform for the more senior members of the project. This includes pushing the Minetest engine further than anyone ever has before.
- Gameplay - The third, and least important, purpose of this project is to make a fun game. Its still important, but if some aspect that would make QT2 fun contradicts the other two goals, it should not be worked on. This is an unlikely scenario.

### Organization

The QuestTest2 project is primarily managed through its GitHub page: [https://github.com/Fesmaster/QuestTest2](https://github.com/Fesmaster/QuestTest2)

Issues, project boards, and branches are tracked through GitHub.

The two primary branches are "master" and "development". (Side Note: We WILL NOT entertain anyone requesting that the master branch's name be changed, for any reason, real or imagined. If you don't like that, please grow thicker skin.)

The "master" branch contains the current release, and is the primary branch of the project. This branch can be considered "stable". Please note that it is not guaranteed to be bug-free. Each release will be tagged on the master branch for easy legacy version fetching. Check-ins to "development" require review, and should only be made by the Project Owner.

The "development" branch contains the work-in-progress version. It should be considered "semi-stable". It will likely have a number of bugs, and is not necessarily playable. Check-ins to "development" require review.

Various branches beginning with "RC_" signify Release Candidates. Prior to a release, development is branched into a RC branch, which is then tested, bug fixed, and merged into master and development. Release Candidate branches are not removed, and might be used if a hotfix is required.

Other branches that show up are development branches and should be considered "unstable" - they might not run at all.

### Process

Due to the primary purpose of the QuestTest2 project being Education, some of the following processes are unusual.

All work should be defined by an Issue on GitHub. If you have a task you want to work on, discuss it with the Project Owner first - it might not be a good fit. If it is, either you or the Project Owner will create an Issue on GitHub for you.

When beginning work, create a branch, based on the development branch, for your issue. The name of the branch should reflect the issue. Branch names should never contain spaces. For example, if the issue is "Colored carpets" and its about adding colored carpets, a good branch name would be "featureColoredCarpets". In this case, the "feature" came from a likely tag on the issue as a "feature". If you are unsure what to name your branch, ask the Project Owner. Most branches should start with the word "feature".

Work on the feature, regularly committing and pushing your work. Tasks on the issue should ONLY be marked complete when the relevant code is pushed to the repository.

As you work on the feature, you might be simultaneously writing documentation for it. (Content additions and bug fixes likely won't have documentation - but systems will). Each commit should have accompanying documentation written about the features in the same commit. Documentation is written in Markdown (like this document) and belongs in the `/docs/` folder. For information about Markdown formatting, please see the following website: [www.markdownguide.org](https://www.markdownguide.org/basic-syntax/)

When you have finished the feature, rebase your branch on Development (if Development has any changes). This will prevent changes made since you created your branch from breaking your feature or vice versa.

When the feature is complete and the final code is pushed, open a pull request to merge into the development branch. By default, GitHub will open the PR merging into the master branch. You can edit this when creating the PR. Request a review from the Project Owner.

Implement any feedback from the Project Owner in your branch, and commit the changes, re-requesting review.

Once the PR is approved, merge (squash and merge) your feature into the development branch, and delete your feature branch. Don't worry, its always possible to restore deleted branches, but leaving a ton of feature branches dangling is a good way to have people get confused and lost.

When the Project Owner requests review from you, you should read all the code in the review. If there is any code that does not make sense, please ask a question about it as a review comment. If you have trouble understanding how to review code on GitHub, please ask. You should ask at least one question for each review, and try and guess what the answer might be. Learning to read and understand code is just as important as learning to write it.

When all your questions are answered, approve the review.

## Pillars

1. Exploration
2. Building
3. Combat
4. Narrative

### Exploration

Traveling the procedurally generated world should expose the player to the wonder of discovery. The world should be alive and old, with a sense it has been there long before the player arrive, and exist long after.

The landscape will be procedurally generated using a custom generation system. Placed around the landscape will be varous points of interest ("structures"). These structures will provide a reason for the player to explore, given that they are built to engage the player in the other pillars.

Some structures will be unique, only one placed per world. Others will be placed many times. Structures are not fixed in design, but can be dynamically generated at runtime. Each structure should be at least somewhat different.

To facilitate the player's sense of progression and to facilitate further exploration, each structure discovered will add a waypoint to the player's list, allowing the player to either activate it visibly on the screen, or to fast-travel to that structure.

Structures can be as small as a strange monolith in the middle of a desert to as large as a major city 500 blocks (meters) across. (NOTE: This number is a rough estimate)

The wilds outside of structures should present exploration opportunities themselves. Resource gathering, finding a place to make a base, or hunting creatures or enemies.

Since the world itself is inherently navigable, moving around it should feel good. To this end, sprinting and dodging will be added to Minetest's default movement systems, and crouching will be improved.

### Building

Following the focus of player-driven interaction, the player has nearly unlimited ability to change the world around them. To make the most of this, QuestTest2 encourages players to build bases, and facilitates the desire to decorate such bases with little details.

QuestTest2 needs a robust pallet of placable nodes, both in color, shape, and type. While skilled players with an artistic mind can make great use of limited pallets, increasing the pallet will help less artistically minded players by giving them direct representation of objects rather than indirect lookalikes. At the same time, it gives artistically minded players more toys to play and create with.

Building should also be essential for progression. Some types of crafting require large structures in the world to facilitate. Almost all crafting requires the players have some node placed nearby to make the recipes available.

To help with players managing large numbers of items, a storage system should be built into the game, with the ability to search items, filter, manage storage locations and types. Similar principles should be applied to the item list available from the player inventory, and used to select what to craft.

### Combat

Growth can only happen because of struggle. The world is a dangerous place. These statements apply to the world of QuestTest2. Around every corner, a potential enemy lurks, or a potential ally. Traveling the world can lead one to encounter bandits, goblins, or terrifying monsters of the deep.

Each of these can be challenged, each can be defeated. The rewards for defeating a legendary monster should be equally legendary.

QuestTest2 improved on Minetest's "Hit it till it dies" combat system by introducing dodges, stealth, archery, and magic (note that magic is not just for combat). E

Dodging is to make combat based more on skill than on hit point management. Dodging allows both the player and the AI to avoid attacks strategically.

Stealth allows for enemies to be bypassed or assassinated.

Archery allows for ranged attacks against enemies - there is always a moment between when an enemy sees you and they are close enough to hit you.

Magic makes the field of combat more dynamic. Shields, flight, AoE effects, and the like take the simple combat arena and change it every second.

### Narrative

Player-driven storytelling should be the primary form of storytelling. Instead of having the player react to events in the world, the world should react to the player.

Examples:
The player finds a new town. They can

- Talk with people, and offer their services. Might get some quests to help the citizens
- Vandalize the inn. The guards will turn aggressive and many of the citizens will dislike the player. The owner of a rival inn might offer the player a secret job, however.
- Find the mayor and offer services. Possible quest, or nothing.
- Assassinate the mayor and forcibly take over the town. Now the player is mayor. But the people might not like the player.

Each NPC should be both killable and have a generated quest that can be completed. Each NPC should have a faction. Factions have relationship ranks with the player. Individual NPCs can have personal ranks adjusted from this. Example: most farmers in a town hate the player because he burned down their fields, but one specifically loves the player because burning down the other farmer's fields was a quest for him.

This sort of player-driven storytelling requires a quest generation system that can react to the player's actions in the game.

Several named and designed NPCs can be found or move into the Player's town (if the player has one). These should offer pre-created quests. Having hand-designed content interspersed with the generated content gives the game a sense of identity.

## Setting

QuestTest2 is set in a fantasy medieval world. The primary inhabitants are Humans, who make most peaceful NPCs and bandits. Other species, including goblins, exist as well.

Magic is common enough for most people to have seen it used, if they don't know some of the basic usage.

The world has fallen into recession. Some time before, a major empire fell apart, throwing the world into chaos. None alive now remember it, and its remnants are rotting. Monsters, which were once nearly extinct, are making a resurgence. Roads once safe are now fraught with peril. The culture reflects this. Individual trade has ground to a halt. Individual towns are self-governing, and no countries exist. Travel between cities is only done in large groups, except on a few well-guarded roads.

The more brave among the residents have moved out of the cities, preferring to live outside of the crumbling remnants of society. These wanderers are often skilled at fighting or avoiding the creatures that now wander the land. Others leave in groups, preying upon travelers. Some say these bandits are worse than the monsters, because they know what they do.

## Development

QuestTest2 Development is on an "as-available" basis. Most of the people working on this project are working full-time elsewhere, either at jobs, school, or both. Given this time commitment, development here is a secondary priority.

However, we would like to see the project continue forward. This section describes development tools and utilities.

### Artistic Style

Due to engine limitations and conventions, most blocks use a 16x16 images for their textures. Because of this, QT2 has a pixelized, stylized aesthetic. It aims to be vibrant and colorful, with minimal grit, and a feeling of smoothness to its looks.

Some items will use a 32x32 texture for the inventory, and very rarely for nodes. High-detail items might use 64x64 textures. Only UI textures should exceed this size.

UI artistic style is still an area of active research and development.

### Tools

QuestTest2 is primarily written in Lua.

For a code editor and IDE, we use Visual Studio Code (VS Code).

Visual Studio Code extensions that we recommend:

- Lua Language Server coded by Lua (Lua) by sumneko - this provides Lua Linting and autocompletion. QuestTest2 is making an effort to use its system of annotations for good autocompletion suggestions. This is effectively spellcheck for code that can help check for errors without having to run the code, if you use it correctly. You should absolutely use this.
- Lua Remote DeBugger (LRDB) by satoren - While default minetest does not support this, we are looking into distributing a custom build of Minetest that does. It allows you to put breakpoints in Lua and have Minetest stop running for examination when the execution reaches that point.
- markdownlint by Davin Anson - Useful for writing markdown documentation in VS Code.
- Git Graph by mhutchie - This is a very useful tool that lets you do git-related stuff straight from VS Code
- Git Extension Pack by Don Jaymanne (Optional)
- GitLens by GitKraken (Very optional)
- Code Spell Checker by Street Side Software - Helpful when writing documentation to check for typos.

We use Git for source control. You will need both the binary "git" program, and a git gui. There are many available. Some work directly inside of Visual Studio, like Git Graph, while others are external. [Tourtis Git](https://tortoisegit.org/) is a useful one for Windows users that integrates directly into Windows Explorer.

To edit NodeBoxes, we use our own Nodebox Editor found here: [https://editor.p5js.org/Fesmaster/sketches/9Qnd12f6w](https://editor.p5js.org/Fesmaster/sketches/9Qnd12f6w)

The use of generative AI to write code or create assets is ***FORBIDDEN***. This creates legal complications, because we do not know where it took that work from (in whole or in part), and it can create a license conflict. This includes GitHub Copilot, Chat GPT, and similar systems.

For artistic tools, [Blender](https://www.blender.org/) is the 3D modeling tool of choice. Since for some inane reason, Minetest still only supports .b3d and .x model formats for animated meshes, these two exporter plugins for Blender are needed:

- [io_scene_x](https://github.com/minetest/io_scene_x)
- [B3DExport](https://github.com/minetest/B3DExport)

Of course, these plugins only support older versions of Minetest.
This is an area of active reaserch for QuestTest2.

For Textures, [GIMP](https://www.gimp.org/) is the recommended tool.

Creating or finding new and better tools for the development of QuestTest2 is an ongoing effort. If you find a tool, please recommend it.

### Internal Tools

QuestTest2 has several tools built into it. These are (usually) part of the dtools mod. Most of these tools require the world to be loaded with DEVMODE enabled. To enable devmode on a world, run the chatcommand `/devmode on`, then re-load the world.

DEVMODE is not intended to be playable. Nodes like structure generators will not work autogenerate structures in DEVMODE, and mob spawners are not invisible. On the other hand, debug items and development tools are made available. DEVMODE is intended to test and develop QuestTest2 functionality.

## Gameplay and Systems

This section of the GDD deals with the design of playing the game. It covers player interactions and game design elements.

### Core Game Loop

The core game loop is primarily about resource management - you need resources to generate resources, and all resources are consumable.

Just because you have access to higher tiers of resources does not mean you no longer have interest in the lower tiers - indeed, the lower tiers might still be really valuable.

- Travel to find resources or structures
- Collect Resources from various sources, such as direct gathering, quest rewards, loot, mob drops
- Use those Resources to build structures, craft gear, or otherwise improve your ability to travel and collect resources. 

### Managing Resources

Since the game is primarily about resources, how the player can managing collecting, storing, and utilizing those resources is a key area of design, and a key area we want to differentiate ourselves against most games for Minetest (and potentially against most voxel games and RPGs in general)

Collecting resources that require low amounts is left as an incentive for the various pillars of the game, in differing ways. Common resources should have more effective ways of collecting them, including methods that can be automated.

To store resources, QuestTest2 does two things:

1. The stack max is raised from 99 to 1024. Configuration can be used to raise this higher.
2. A planned native Storage Systems called Quartermaster that seamlessly links all nearby storage objects.

To utilize resources, it depends on what type of utilization.

For blocks used to build, the greater stack max allows for more to be carried and used. The Shaped Nodes system condenses stair, slab, and slant blocks into one block type in the inventory. Hammers easily change between types, and a planned feature to middle-click and change the default placed type is in the works.

For crafting, much common crafting is done straight from the inventory. Inventory-based crafting should respect Quartermaster and allow usage of items stored in a Quartermaster network as ingredients.

Most crafting should also be automatable. Automated crafting systems can help build bulk items from base resources and combine well with automated resource harvesting.

For weapons, tools, and the like, they should all have a durability. This requires constant refresh of the materials required to make a tool, increasing the need to gather resources.

Consumables, such as food, potions, and grenades, are destroyed upon use. Some of these items should be able to be bound to hotkeys.

### Primary Game Systems

Not all of these systems directly affect gameplay, some are underlying code systems that affect how we can make the gameplay better.

Most of these systems exist primarily in the module `qts` (short for )

For documentation on how each of the systems work in detail, please refer to the document titled after that system. Links are placed here for reference if the document exists.

- Shaped Nodes: Allows for many nodes to have stair (straight, inner, outer), slab, and slant (straight, inner, outer) versions. No extra registrations are needed. Provides a system to "hammer" nodes to different shapes or rotate them. Also allows for custom hammering actions, for example, to remove posts from a fence (fence->rail->fence->... conversions).
- [Scribe](./scribe.md): Allows for good GUI systems to be made with much more ease than with Formspec.
- health override: We completely overrode how Minetest handles health and armor. This system does not have a name.
- crafting system: We designed our own crafting system. Minetest's system of 9-square recipes was not the type of crafting we wanted, since it limits the way ingredients can be assembled. Instead, we built a system that just requires the ingredients, some non-consumed tools, and certain nearby blocks
- Creatures - Allows for optimized entities with a generalized Finite State Machine AI to be created easily. Independent AI modules can be attached to a creature (even at runtime) to give it certain behavior.
- Pentool (incomplete): This system adds a turtle graphics-like system to assist in generating structures.
- Mechanics (not started): This system adds mechanical contraptions that can be linked, allowing you to create complex machines.
- Quartermaster (not started): A system to link storage nodes and provide a unified access to them for item storage and crafting.

### World Organization

The world is organized in vertical layers, like the slices of a cake. The further you get, vertically, from the world origin (0,0,0), the more difficult and higher level the content gets.

#### Overworld

The starting area of the world, the Overworld compasses the vertical slice from -300 to 150. This area is the easiest to survive in, and contains much of the game's early content.

##### Biomes of the Overworld

These biomes and their features and resources represent the current state. An overhaul of biomes in in progress, and a major overhaul of worldgen is planned.

- Grasslands:
  - Surface: Green
  - Trees: None
  - Stone: Granite
- Woods:
  - Surface: Green
  - Trees: Apple, Oak, Aspen, Rowan
  - Stone: Granite
- Prarie:
  - Surface: Dry brown/tan
  - Trees: Rosewood
  - Stone: Granite
- Swamp:
  - Surface: Rich green, water
  - Trees: Bamboo, Swamp tree
  - Stone: Granite
- Rainforest:
  - Surface: Dark brown forest litter
  - Trees: Coffee, Mahogany, Lanternfruit
  - Stone: Granite
- Mushroom Forest:
  - Surface: White mushroom tendrils
  - Trees: Mushrooms (Blue, Brown, Gold)
  - Stone: Granite
- Desert:
  - Surface: desert sand
  - Trees: none
  - Stone: sandstone
- Mountain:
  - Surface: raw dirt and granite, covered in snow
  - Trees: none
  - Stone: granite
- Desert Mountain:
  - Surface: sandstone
  - Trees: none
  - Stone: sandstone
- Beach:
  - Surface: sand, with beach grass
  - Trees: Palm
  - Stone: limestone
- Underwater:
  - Surface: sand
  - Trees: None
  - Stone: granite
- Snow:
  - Surface: snow-covered dirt
  - Trees: Pine
  - Stone: granite
- Snowy Beach:
  - Surface: sand, with snow
  - Trees: None
  - Stone: limestone

#### Cave Realm (Crystal Caves)

Inspired by the Glittering Caves behind the Hornburg, the Crystal Caves lies from about -700 to -300. It is characterized by large, open caverans with many glowing crystals. Much of this biome is not yet implemented.

##### Biomes of the Crystal Caves

- Shards: Characterized by many small glowing crystals of purple, green, and blue, the Shards is also where Mese can be mined. The dark blueish slate stone makes the environment darker and the crystals stand out.
- 