// ELDERBORN autosplitter/load remover by Kainalo

// State
state("Elderborn")
{
	byte loading : "UnityPlayer.dll", 0x1451870, 0x28;
	byte inMenu : "mono.dll", 0x02675E0, 0x90, 0x10, 0x1F48, 0x38, 0x50, 0x50, 0x70, 0x38;
	uint towerRedDead : "UnityPlayer.dll", 0x146FCC8, 0x8, 0x10, 0xB8, 0x80, 0xD8, 0x48, 0x20, 0x61;
	uint towerYellowDead : "UnityPlayer.dll", 0x146FCC8, 0x8, 0x10, 0xB8, 0x80, 0xD8, 0x70, 0x20, 0x61;
	uint towerBlueDead : "UnityPlayer.dll", 0x13B58F0, 0x28, 0x1D20, 0x70, 0x2A0, 0x30, 0x98, 0x60, 0x61;
	byte janusDead : "UnityPlayer.dll", 0x147F910, 0x40, 0xA38, 0x30, 0x30, 0x58, 0x28, 0x150, 0x170;
	uint janusPhase : "mono.dll", 0x0264110, 0x900, 0x0, 0xA0, 0x0, 0x58, 0x90, 0x38, 0x44C;
	byte world : "UnityPlayer.dll", 0x1449580, 0xD8, 0x50, 0x368, 0xA0, 0x610, 0x0, 0x20, 0x74;
	byte feverUsed : "mono.dll", 0x0264110, 0x1F0, 0xF0, 0x120, 0x40, 0x148, 0x8, 0x20, 0xBD;
	byte arenaFinished : "UnityPlayer.dll", 0x1449AF0, 0x10, 0x160, 0x10, 0xA0, 0x6E8, 0x10, 0x20, 0xBF;
	byte arenaCurWave : "UnityPlayer.dll", 0x146E520, 0x3B8, 0x0, 0x18, 0x30, 0xB8, 0x80, 0x40, 0xB4;
	byte puzzleSolved : "UnityPlayer.dll", 0x147F910, 0x40, 0x1F8, 0x30, 0x70, 0x0, 0x98, 0x28, 0x6D0;
}

// Initialization
init
{
	vars.fresh = 0;
	vars.split = 0;	
	vars.janusSplit = 0;
	vars.redSplit = 0;
	vars.yellowSplit = 0;
	vars.blueSplit = 0;
	vars.currentArena = 0;
}

// Updating
update
{

}

// Startup
startup
{
    settings.Add("optionLoads", true, "Load Removal");
	settings.SetToolTip("optionLoads", "Remove loads");
	
    settings.Add("optionJanus", true, "Janus Dead Split");
	settings.SetToolTip("optionJanus", "Splits when Janus dies in the C1 bossfight");
	
	settings.Add("optionJanusPhases", true, "Janus Phases Split");
	settings.SetToolTip("optionJanusPhases", "Splits when Janus changes phases (3 phases)");
	
	settings.Add("optionJanusBegin", true, "Janus Fight Start Split");
	settings.SetToolTip("optionJanusBegin", "Splits when Janus fight starts");
	
    settings.Add("optionRedTower", true, "Red Tower Split");
	settings.SetToolTip("optionRedTower", "Splits when Red Tower Priest has died");
	
    settings.Add("optionYellowTower", true, "Yellow Tower Split");
	settings.SetToolTip("optionYellowTower", "Splits when Yellow Tower Priest has died");
	
    settings.Add("optionBlueTower", true, "Blue Tower Split");
	settings.SetToolTip("optionBlueTower", "Splits when Blue Tower Priest has died");	

    settings.Add("optionWorld", true, "Split on world change");
	settings.SetToolTip("optionWorld", "Split when the world Changes");
	
    settings.Add("optionArena", true, "Individual Arena Splits");
	settings.SetToolTip("optionArena", "Splits after every Arena fight (6Fights)");
	
    settings.Add("optionOutro", true, "Outro Split");
	settings.SetToolTip("optionOutro", "Split when entering the outro from the Arena");
	
    settings.Add("optionPuzzle", true, "Puzzle/C2Boss Split");
	settings.SetToolTip("optionPuzzle", "Split when the boss puzzle is solved in C2");
}

 // Start Timer
start
{
	if (current.loading == 0 && old.loading == 1 && old.inMenu == 1 && current.inMenu == 0)
    {
		vars.fresh = 1;
		vars.janusSplit = 0;
		vars.redSplit = 0;
		vars.yellowSplit = 0;
		vars.blueSplit = 0;
		vars.currentArena = 0;
        return true;
    }

}

// Split
split
{	
	bool janusDedSplit = vars.janusSplit == 0 && current.janusDead == 1 && old.janusDead == 0 && settings["optionJanus"] && current.world == 1;
	
	bool janusPhaseSplit = current.janusPhase == (old.janusPhase + 1) && current.janusPhase != 1 && settings["optionJanusPhases"] && current.world == 1;
	
	bool janusStartSplit = current.janusPhase == 1 && old.janusPhase == 0 && settings["optionJanusBegin"] && current.world == 1;

	bool towerRedDeadSplit = vars.redSplit == 0 && current.towerRedDead == 1 && old.towerRedDead == 0 && settings["optionRedTower"] && current.world == 2;

	bool towerYellowDeadSplit = vars.yellowSplit == 0 && current.towerYellowDead == 1 && old.towerYellowDead == 0 && settings["optionYellowTower"] && current.world == 2;

	bool towerBlueDeadSplit = vars.blueSplit == 0 && current.towerBlueDead == 1 && old.towerBlueDead == 0 && settings["optionBlueTower"] && current.world == 2;

	bool worldSwap = current.world > old.world && settings["optionWorld"];

	bool arenaSwap = (current.arenaCurWave > vars.currentArena) && settings["optionArena"] && current.world == 3 && current.arenaCurWave != 255 && old.arenaCurWave != 255;

	bool arenaDone = current.arenaFinished == 1 && old.arenaFinished == 0 && current.world == 3 && settings["optionArena"];

	bool outroSplit = settings["optionOutro"] && current.arenaFinished == 1 && current.feverUsed == 1 && current.world == 3;

	bool puzzleSplit = settings["optionPuzzle"] && current.puzzleSolved == 1 && old.puzzleSolved == 0 && current.world == 2;
	
	if (janusDedSplit) {vars.janusSplit = 1;}
	if (towerRedDeadSplit) {vars.redSplit = 1;}
	if (towerYellowDeadSplit) {vars.yellowSplit = 1;}
	if (towerBlueDeadSplit) {vars.blueSplit = 1;}
	if (arenaSwap) {vars.currentArena = current.arenaCurWave;}
	
	return (janusDedSplit || janusPhaseSplit || janusStartSplit || towerRedDeadSplit || towerYellowDeadSplit || towerBlueDeadSplit || worldSwap || arenaSwap || arenaDone || outroSplit || puzzleSplit);

}

// Reset
reset
{
	return current.inMenu == 1;
}

isLoading
{
	return current.loading == 1 && settings["optionLoads"];
}
