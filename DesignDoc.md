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

## Art

It is essential to have a consistent art style, a consistent visual feel for the game. 

Nodes should use 16x16 textures, unless there is some good reason to use a higher res texture. An example of a good reason to use a higher res texture is rope, where the nodebox is too small for 16x16 to look good. Another reason may be to capture tiny sparkle detail for magic items. 

Inventory and Wielditem only textures should be 32x32 for the higher detail.

Pixel shading is important. Due to the nature of the graphics, it is desirable to lean into the stylized astetic.

Warm colors are preferred. Blue lighting and highlights are to be avoided, it feels too cold.
