# Quest Test 2 Design Doc

## Purpose
More than one purpose exists, making parts of this project difficult.

1. Code Learning environment - some members of the project are new to programming and the content-creation area provides a good entry point.
2. Pushing Minetest Engine - The Minetest Engine is pretty awesome, but few things I have seen push it to its limits, its mods never seem as expansive or imaginative as mods for other voxel games, despite having a much more open modding API and built in mod manager.
3. Interconnectivity - This should have a modding framework that sits on top of the Minetest API that allows individual mods to play much more nicely with each other than the current system.
4. Prototyping - Learn from this project more about making voxel projects and what goes into them, gameplay and content-wise.

## QTS

QTS (Quest Test System) is a monolithic mod designed to fulfill the goals of Interconnectivity and Pushing Minetest Engine. 

In the general modding community, there is an incredible effort to make many mods work together. Mods that add, for example, paraffin, will often check for each other to make sure they are adding the same paraffin. 

However, there are still problems. Say a mod adds a new metal, and all associated tools. But did they check for all the armor mods to add armors for each one? What about comparability for a different mod that changes metal-based progression entirely?

These problems cannot entirely be solved, but a centralized expansive API for many of these things are designed to make QuestTest more versatile in this manner. 

Second, this element provides a method for driving expansion of the Minetest API, allowing it to be pushed further. Examples of this include the UI system, the shaped nodes, and similar systems. These extra layers of abstraction allow for more complex gameplay ideas to be manifested. 

The largest example of this is the Health system. Health with QTS is written entirely on top of Minetest's health. Your Minetest health does not change when you loose health, only a QTS health value. This allows us to change how armor is calculated to be more friendly to scaling.

QTS should not, however, provide gameplay explicitly. It assumes some, such as doors exist in potentiality, but does not make any doors or behavior of its own.

Some gameplay systems QTS does implement are its custom craft recipe system. This is currently unavoidable.

## Gameplay

There are four pillars of gameplay:

1. Exploration
2. Building
3. Conquest
4. Resource Management

### Exploration

Physical movement around the game world should be fun in itself, thus, the sprint system was made, and more features regarding this should be put into effect.

There should be plenty to find by exploring the world, plenty of materials to search for, unique places to find, enemies to fight, etc. To this end, each biome should have different surface features, different plants, stones, even soils. There should be different dungeons that spawn in each, different camps, enemies.

Layers of the world are a major principle, sometimes called dimensions. These are all accessible via the "normal" way: dig or build to them. Each one should be a complete world with its own biomes, features, dungeons, resources, etc. Each should make it a bit easier to reach the next.

### Building

Encouraging players to build large bases is a central principle. To this end, there are two major efforts:

1. Plenty of building materials
2. Gameplay reasons to build

Artistic nodes, of various types, help encourage building by inspiring the imagination. To this end, most stones come with plenty of patters, all furniture has unique shapes for each wood, and many other elements, such as chests and doors, visually change depending on the wood and metal used to make them. On top of this, plenty of decorative things exist, from placeable ingots, stackable apples, piles of seeds and other dust-type materials, and other decoratory elements. 

Gameplay reasons to build are organized around game progression. Crafting has been changed to require nodes to be placed near to the player to work, as well as some crafting requires interacting with the world to accomplish.

Two examples: Most basic crafting requires a crafting or advanced crafting table to be placed near to the player. This is a simple requirement, but it ties the player to a base. Further beyond this, crafting things from metal require a furnace and an anvil nearby, expanding this requirement. Other things, such as food, alchemical potions, and other more complex crafts require more and more variety of nodes nearby to craft. 

The second example is the smelting of metal. Foundries, not to be confused with the single-node Furnaces, are large structures, at a minimum, 3x2x3 blocks, but going up to 3x4x3 blocks. The height difference is a major difference, a full-sized foundry holds 3x as much metal as a minimal one. They require significant investment to make, and are limited in what they can smelt simultaneously, encouraging the player to make a number of them. 

### Conquest

This game is not about defending one's territory, no, it is about conquering the world. The monsters, the dark, exist, and you must go find them.

There are several reasons for this. 

1. It allows you to not fight when you don't want to (mostly).
2. It encourages exploration, particularly when you want to fight or need materials.
3. It fits more with the nature of the gameplay.

If the enemies are not hunting the player, not coming after the player, then the player gets the choice to fight or not to fight at any given time. This is preferred for the pacing of the game, allowing the player large stretches of time to focus on other tasks, such as building, without the threat of an attack. To this end, enemies will only spawn at specific locations in the world, clustered around camps, dungeons, and similar structures. This allows them to be clearly identified, so they can be avoided or hunted.

If the enemies exist in specific locations in the world, then the player must explore to find them. If they drop or are guarding materials unique to that location or unique to them, then there is reason to hunt them down. This re-enforces the exploration pillar.

The nature of the gameplay, as a voxel world, is that the player can change the world intelligently, but the ability of creatures to do so is heavily limited. Thus, it makes sense th at the player is the alpha predator of this world. Either way, this will happen; the player will find a way to dominate the world, the spawn mechanics, and dominate. The idea is to assume this as the default, encourage it, and make the game revolve around it. Each new enemy, each new area, presents new challenges to conquer it, not to survive within it.

Hand in hand with this goes the progression of the game. The game should be able to estimate the level of the player based off of what materials they have acquired, what armor they wield, what tier of tools they carry. This level should effect what types of enemies spawn at a particular location, what gear they have, and thus how dangerous they are to the player. 

Just because the game is centered around a conquest mentality, the enemies should not be easy. To this end, dodging was added, though its still a bit broken. Enemy attacks should not be just "run up and hit!", but be far more varied and intelligent. They should flee when nearly dead. Attack at range, use the environment, and use special abilities. They should be able to pick up and use the same items the player can, from weapons to armor to magic staves. 

### Resource Management

The pillar of resource management includes crafting, storage, and sourcing materials.

Crafting should be both simple and engaging. For this purpose, we removed the crafting table that required people to learn or search recipes, replacing it with a system to search recipes, click buttons to craft, but also require things placed in the world or in the inventory but not consumed. This allows us to also have craft recipes that have multiple outputs, and "virtual" recipes that cannot be crafted but detail where certain items can be found.

Crafting more complex things should involve some interaction with the world. Foundries, for turning ore into metal, are an excellent example. These are large structures that require maintenance to work, and have several different points with with to interact to use them. A smaller example is dying cloth armor: you have to rightclick the armor on a bottle of dye. 

Storage is a common problem. One thing we want to avoid is an ugly wall of chests. To facilitate this, chests themselves are designed more as detail pieces, with crates being storage that takes a full block. Then, other pieces of furniture have storage attached, and this can be expanded. This further encourages the building pillar, particularly in the area of making a nice looking base. 
A specific effort to alleviate the storage issue is to increase the stack max size from 99 to 999 for nearly everything. This facilitates building, too, as it allows you to make less trips to refresh material stores when constructing something.

Sourcing materials is intended to be a major challenge in the game, controlling progression. This is not the same thing as making the game have a large material grind. Materials should be plentiful, just restricted in access. For example, to get to metals, you have to get underground, have a pickaxe, and have built a foundry. But to get to gold and gemstones needed for magic, you need to go much deeper. 

Similarly for other materials, you have to get to where the material is found, but once there, its no grind to get the amount you need, not only to progress, but also to do more optional things.

## Art

It is essential to have a consistent art style, a consistent visual feel for the game. 

Nodes should use 16x16 textures, unless there is some good reason to use a higher res texture. An example of a good reason to use a higher res texture is rope, where the nodebox is too small for 16x16 to look good. Another reason may be to capture tiny sparkle detail for magic items. 

Inventory and Wielditem only textures should be 32x32 for the higher detail.

Pixel shading is important. Due to the nature of the graphics, it is desirable to lean into the stylized astetic.

Warm colors are preferred. Blue lighting and highlights are to be avoided, it feels too cold.

## Branching Strategy

The primary release branch is master and should never be pushed to.
The primary development branch is Development and should never be pushed to.

Feature branches (which should start with Feature_ or Bugfix_ but do not have to) are branched off of Development, and then merged back when done via a PR (Pull Request) All pull requests should have at least one person assigned as a Reviewer, preferably Fesmaster. The feature is then Squashed and Merged back into development.

When a release is ready, Development is branched to a new branch, `RC_<releaseversion>`. This branch is the Release Candidate, and should be thoroughly bug tested (decent play through of much content.) Once ready, it is Squashed and Merged back into Development as a Bugfix, (if necessary) and Squashed and Merged into master as the release number. This release is then Tagged.

Hotfixes are branched from master and merged to master and development.