#pragma once

class mgCMemory;

/**
 * Populates party-character records from the selected native configuration.
 */
void PortLoadNPCConfiguration();

/**
 * Allocates villager places, schedules and story progress from native configurations.
 */
void PortLoadVillagerConfiguration(mgCMemory *memory);

struct INIT_LOOP_ARG;

/**
 * Initializes movie viewing with directly decoded native configuration commands.
 */
void PortInitializeMovieViewer(INIT_LOOP_ARG argument);

/**
 * Loads the development gyorace configuration from the host save directory.
 */
void PortLoadDebugGyoraceConfiguration();
