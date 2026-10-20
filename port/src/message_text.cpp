#include "common.h"

#include <cstdint>
#include <map>
#include <string_view>
#include <tuple>
#include <utility>
#include <vector>

#include "mainloop.hpp"
#include "nd_meswin.hpp"

// The PAL disc's menu and system messages describe PS2 memory cards, their slots and the console.
// The PC port keeps saves, the photo album and Extras data in folders, so the messages that
// mention them are replaced here in every PAL language, as text in the message's own encoding.
// Menu message 153, shown when an item is over its carrying limit, is replaced too, so that it
// names the item and the limit as the Japanese text does and the PAL translations do not. The disc
// files are recognised by their header words; any other message file is left as it is.

namespace {

enum class MesFile {
    kAllMenu,
    kSysMes
};

struct KnownFile {
    MesFile       file;
    int           language;
    std::uint16_t count;
    std::uint16_t word1;
};

// Header words of menu/<language>/*.pac:allmenu.mes and meswin/sysmes_<language>.mes on the PAL disc.
constexpr KnownFile kKnownFiles[] = {
    {.file = MesFile::kAllMenu, .language = 1, .count = 933, .word1 = 14870},
    {.file = MesFile::kAllMenu, .language = 2, .count = 934, .word1 = 16394},
    {.file = MesFile::kAllMenu, .language = 3, .count = 933, .word1 = 11090},
    {.file = MesFile::kAllMenu, .language = 4, .count = 934, .word1 = 17338},
    {.file = MesFile::kAllMenu, .language = 5, .count = 934, .word1 = 20008},
    {.file = MesFile::kSysMes,  .language = 1, .count = 360, .word1 = 27192},
    {.file = MesFile::kSysMes,  .language = 2, .count = 360, .word1 = 28058},
    {.file = MesFile::kSysMes,  .language = 3, .count = 360, .word1 = 24658},
    {.file = MesFile::kSysMes,  .language = 4, .count = 360, .word1 = 27594},
    {.file = MesFile::kSysMes,  .language = 5, .count = 360, .word1 = 27654},
};

struct Replacement {
    MesFile          file;
    int              language;
    int              id;
    std::string_view text;
};

// UTF-8. "\n" is a line break, "{XXXX}" a raw message code ({FBFA} the slot number or the item
// limit, {FBF9} the size in KB, {FAF9} the item name, {FD07} Triangle), and "{TAIL}" the original
// message's last line, which holds the button prompts.
constexpr Replacement kReplacements[] = {
    // English
    {.file = MesFile::kAllMenu, .language = 1, .id = 153,  .text = "You can only carry {FBFA} \"{FAF9}\".\nPress {FD07} to Move or use the\n\"Throw away\" command to tidy up."            },
    {.file = MesFile::kAllMenu, .language = 1, .id = 670,  .text = "View Album?"                                                                                                           },
    {.file = MesFile::kAllMenu, .language = 1, .id = 671,  .text = "No Album data was found."                                                                                              },
    {.file = MesFile::kAllMenu, .language = 1, .id = 673,  .text = "Save current Album?"                                                                                                   },
    {.file = MesFile::kAllMenu, .language = 1, .id = 678,  .text = "No Album data was found\nin this Album.\nCreate a new Album?"                                                          },
    {.file = MesFile::kAllMenu, .language = 1, .id = 679,  .text = "Insufficient space\nfor album data (490KB required)."                                                                  },
    {.file = MesFile::kAllMenu, .language = 1, .id = 684,  .text = "Select an Album.\n   Album 1\n   Album 2"                                                                              },
    {.file = MesFile::kAllMenu, .language = 1, .id = 687,  .text = "Saving the Album..."                                                                                                   },
    {.file = MesFile::kAllMenu, .language = 1, .id = 689,  .text = "No Album data was found\nin this Album.\n490KB of free space\nis needed for Album data.\nCreate an Album?"             },
    {.file = MesFile::kAllMenu, .language = 1, .id = 691,  .text = "This Album is not set up.\nSet it up now?"                                                                             },
    {.file = MesFile::kAllMenu, .language = 1, .id = 692,  .text = "Select where to\nsave the Album data.\n   Album 1\n   Album 2"                                                         },
    {.file = MesFile::kAllMenu, .language = 1, .id = 693,  .text = "No Album data was found\nin this Album."                                                                               },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3000, .text = "Use which slot?\n   Slot 1\n   Slot 2"                                                                                 },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3001, .text = "Slot {FBFA} is not available."                                                                                         },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3002, .text = "Failed to read slot {FBFA}."                                                                                           },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3003, .text = "Now reading..."                                                                                                        },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3004, .text = "Not enough free space in slot {FBFA}.\nAt least {FBF9}KB is necessary\nfor a new file."                                },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3005, .text = "Failed to read slot {FBFA}."                                                                                           },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3007, .text = "Saving data...\nPlease do not close the game."                                                                         },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3010, .text = "Slot {FBFA} is not set up.\nSet it up and create a new file?"                                                          },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3013, .text = "Reading data..."                                                                                                       },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3041, .text = "Loading data...\nPlease do not close the game."                                                                        },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3043, .text = "Slot {FBFA} contains\nno Dark Chronicle data."                                                                         },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3044, .text = "Slot {FBFA} is not set up.\nSet it up and create a new file?"                                                          },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3046, .text = "There is not enough free space."                                                                                       },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3047, .text = "No slot is available."                                                                                                 },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3048, .text = "Setting up slot {FBFA}...\nPlease do not close the game."                                                              },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3050, .text = "The slot is not set up."                                                                                               },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3051, .text = "The slot is not set up.\nSet it up?"                                                                                   },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3052, .text = "Set up the slot?"                                                                                                      },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3053, .text = "Slot {FBFA} is not set up.\nPlease choose a slot containing\na Dark Chronicle save file."                              },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3060, .text = "Clear the slot?"                                                                                                       },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3070, .text = "Save progress?"                                                                                                        },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3100, .text = "Select a slot."                                                                                                        },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3103, .text = "Slot 1"                                                                                                                },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3104, .text = "Slot 2"                                                                                                                },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3150, .text = "Saves Extras data.\nPlease choose...\n   Slot 1\n   Slot 2"                                                            },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3151, .text = "Loads Extras data.\nPlease choose...\n   Slot 1\n   Slot 2"                                                            },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3152, .text = "Not enough free space in slot {FBFA}.\nAt least {FBF9}KB is necessary\nfor a new Extras file."                         },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3153, .text = "No Extras data was found\nin this slot.\n{FBF9}KB of free space is needed to\ncreate a new Extras "
                                                                   "file.\nCreate a new Extras file now?"                        },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3154, .text = "Extras data in slot {FBFA}\nmay be corrupted.\nPlease delete it from the save folder."                                 },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3158, .text = "This will overwrite Extras data\nin slot {FBFA}.\nSave anyway?"                                                        },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3159, .text = "Load Extras data from slot {FBFA}?"                                                                                    },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3161, .text = "No Extras data was found\nin this slot.\nBegin Extras anyway?"                                                         },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3162, .text = "No Extras data was found\nin this slot."                                                                               },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3164, .text = "Saving..."                                                                                                             },
    {.file = MesFile::kAllMenu, .language = 1, .id = 3165, .text = "Loading..."                                                                                                            },
    {.file = MesFile::kSysMes,  .language = 1, .id = 100,  .text = "Game data cannot be saved.\nAt least 502KB of free space is required\nto save game data. Continue without "
                                                                 "saving?{TAIL}"                                                  },
    {.file = MesFile::kSysMes,  .language = 1, .id = 101,  .text = "There is insufficient space to save.\nAt least 502KB is necessary to\nsave game data. Continue anyway?{TAIL}"          },
    {.file = MesFile::kSysMes,  .language = 1, .id = 102,  .text = "Loading..."                                                                                                            },

    // French
    {.file = MesFile::kAllMenu, .language = 2, .id = 153,  .text = "Tu ne peux porter que {FBFA} \"{FAF9}\".\nAppuie sur {FD07} pour en déplacer\nou utilise la commande \"Jeter\"."       },
    {.file = MesFile::kAllMenu, .language = 2, .id = 670,  .text = "Voir album ?"                                                                                                          },
    {.file = MesFile::kAllMenu, .language = 2, .id = 671,  .text = "Aucune donnée Album."                                                                                                  },
    {.file = MesFile::kAllMenu, .language = 2, .id = 673,  .text = "Sauvegarder l'album ?"                                                                                                 },
    {.file = MesFile::kAllMenu, .language = 2, .id = 678,  .text = "Aucune donnée Album\ndans cet album.\nCréer un nouvel album ?"                                                         },
    {.file = MesFile::kAllMenu, .language = 2, .id = 679,  .text = "490 KB d'espace libre\nsont requis pour créer un album."                                                               },
    {.file = MesFile::kAllMenu, .language = 2, .id = 684,  .text = "Choisis un album.\n   Album Nº1\n   Album Nº2"                                                                         },
    {.file = MesFile::kAllMenu, .language = 2, .id = 687,  .text = "Sauvegarde de l'album..."                                                                                              },
    {.file = MesFile::kAllMenu, .language = 2, .id = 689,  .text = "Pas de données Album\ndans cet album.\n490 KB d'espace libre\nsont requis pour les données Album.\nCréer un "
                                                                  "album ?"                                                       },
    {.file = MesFile::kAllMenu, .language = 2, .id = 691,  .text = "Cet album n'est pas prêt.\nLe préparer ?"                                                                              },
    {.file = MesFile::kAllMenu, .language = 2, .id = 692,  .text = "Choisis où sauvegarder\nl'album.\n   Album Nº1\n   Album Nº2"                                                          },
    {.file = MesFile::kAllMenu, .language = 2, .id = 693,  .text = "Aucune donnée Album\ndans cet album."                                                                                  },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3000, .text = "Utiliser quel emplacement ?\n   Emplacement Nº1\n   Emplacement Nº2"                                                   },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3001, .text = "L'emplacement {FBFA} n'est pas disponible."                                                                            },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3002, .text = "Échec de lecture de l'emplacement {FBFA}."                                                                             },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3003, .text = "Lecture en cours..."                                                                                                   },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3004, .text = "Espace libre insuffisant.\nMinimum {FBF9} KB requis\npour créer un nouveau fichier."                                   },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3005, .text = "Échec de lecture de l'emplacement {FBFA}."                                                                             },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3007, .text = "Sauvegarde des données...\nNe pas quitter le jeu."                                                                     },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3010, .text = "L'emplacement {FBFA} n'est pas prêt.\nLe préparer et créer nouveau fichier ?"                                          },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3013, .text = "Lecture des données..."                                                                                                },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3041, .text = "Chargement des données...\nNe pas quitter le jeu."                                                                     },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3043, .text = "Pas de données du jeu Dark Chronicle\ndans l'emplacement {FBFA}."                                                      },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3044, .text = "L'emplacement {FBFA} n'est pas prêt.\nLe préparer et créer nouveau fichier ?"                                          },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3046, .text = "Pas d'espace libre."                                                                                                   },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3047, .text = "Aucun emplacement disponible."                                                                                         },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3048, .text = "Préparation de l'emplacement {FBFA}...\nNe pas quitter le jeu."                                                        },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3050, .text = "L'emplacement n'est pas prêt."                                                                                         },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3051, .text = "L'emplacement n'est pas prêt.\nLe préparer ?"                                                                          },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3052, .text = "Préparer l'emplacement ?"                                                                                              },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3053, .text = "L'emplacement {FBFA} n'est pas prêt.\nChoisis un emplacement contenant\ndes données du jeu Dark Chronicle."            },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3060, .text = "Vider l'emplacement ?"                                                                                                 },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3070, .text = "Sauvegarder ?"                                                                                                         },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3100, .text = "Choisis un emplacement."                                                                                               },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3103, .text = "Emplacement Nº1"                                                                                                       },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3104, .text = "Emplacement Nº2"                                                                                                       },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3150, .text = "Sauvegarde les données Bonus.\nChoisis l'emplacement :\n   Emplacement Nº1\n   Emplacement Nº2"                        },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3151, .text = "Charge les données Bonus.\nChoisis l'emplacement :\n   Emplacement Nº1\n   Emplacement Nº2"                            },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3152, .text = "Espace libre insuffisant.\nMinimum {FBF9} KB requis\npour un nouveau fichier Bonus."                                   },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3153, .text = "Aucune donnée Bonus dans\ncet emplacement.\n{FBF9} KB d'espace libre\nsont requis pour créer\nun nouveau "
                                                                   "fichier Bonus.\nCréer un nouveau fichier Bonus ?"            },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3154, .text = "Les données Bonus sont peut-être\ncorrompues. Efface-les depuis\nle dossier de sauvegarde."                            },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3158, .text = "Les données Bonus de l'emplacement {FBFA}\nseront écrasées. Sauvegarder quand même ?"                                  },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3159, .text = "Charger les données Bonus ?"                                                                                           },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3161, .text = "Aucune donnée Bonus\ndans cet emplacement.\nLancer Bonus quand même ?"                                                 },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3162, .text = "Aucune donnée Bonus\ndans cet emplacement."                                                                            },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3164, .text = "Sauvegarde..."                                                                                                         },
    {.file = MesFile::kAllMenu, .language = 2, .id = 3165, .text = "Chargement..."                                                                                                         },
    {.file = MesFile::kSysMes,  .language = 2, .id = 100,  .text = "Impossible de sauvegarder les données.\n502 KB d'espace libre minimum sont requis\npour sauvegarder les "
                                                                 "données.\nPoursuivre sans sauvegarder ?{TAIL}"                  },
    {.file = MesFile::kSysMes,  .language = 2, .id = 101,  .text = "Espace libre insuffisant pour sauvegarder.\n502 KB minimum sont nécessaires pour\nsauvegarder les données. "
                                                                 "Continuer ?{TAIL}"                                              },
    {.file = MesFile::kSysMes,  .language = 2, .id = 102,  .text = "Chargement..."                                                                                                         },

    // German
    {.file = MesFile::kAllMenu, .language = 3, .id = 153,  .text = "Du kannst nur {FBFA} \"{FAF9}\" tragen.\nBewegen mit {FD07}-Taste oder\nAufräumen mit \"Wegwerfen\"."                  },
    {.file = MesFile::kAllMenu, .language = 3, .id = 670,  .text = "Album öffnen?"                                                                                                         },
    {.file = MesFile::kAllMenu, .language = 3, .id = 671,  .text = "Keine Album-Daten gefunden."                                                                                           },
    {.file = MesFile::kAllMenu, .language = 3, .id = 673,  .text = "Akt. Album speichern?"                                                                                                 },
    {.file = MesFile::kAllMenu, .language = 3, .id = 678,  .text = "Keine Album-Daten in\ndiesem Album gefunden.\nNeues Album erstellen?"                                                  },
    {.file = MesFile::kAllMenu, .language = 3, .id = 679,  .text = "490 KB freier Speicherplatz\nerforderlich, um Album zu erstellen."                                                     },
    {.file = MesFile::kAllMenu, .language = 3, .id = 684,  .text = "Album wählen.\n  Album 1\n  Album 2"                                                                                   },
    {.file = MesFile::kAllMenu, .language = 3, .id = 687,  .text = "Album wird gespeichert ..."                                                                                            },
    {.file = MesFile::kAllMenu, .language = 3, .id = 689,  .text = "In diesem Album\nkeine Album-Daten gefunden.\n490 KB freier Speicherplatz\nerforderlich für Album-Daten.\nAlbum "
                                                                  "erstellen?"                                                    },
    {.file = MesFile::kAllMenu, .language = 3, .id = 691,  .text = "Dieses Album ist nicht bereit.\nJetzt vorbereiten?"                                                                    },
    {.file = MesFile::kAllMenu, .language = 3, .id = 692,  .text = "Speicherort für die\nAlbum-Daten wählen.\n   Album 1\n   Album 2"                                                      },
    {.file = MesFile::kAllMenu, .language = 3, .id = 693,  .text = "In diesem Album keine\nAlbum-Daten gefunden."                                                                          },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3000, .text = "Welchen Slot verwenden?\n   Slot 1\n   Slot 2"                                                                         },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3001, .text = "Slot {FBFA} ist nicht verfügbar."                                                                                      },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3002, .text = "Lesen von Slot {FBFA} gescheitert."                                                                                    },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3003, .text = "Liest ..."                                                                                                             },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3004, .text = "Nicht genug Platz in Slot {FBFA}.\nMind. {FBF9} KB für neue\nDatei benötigt."                                          },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3005, .text = "Lesen von Slot {FBFA} gescheitert."                                                                                    },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3007, .text = "Speichert ...\nSpiel bitte nicht beenden."                                                                             },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3010, .text = "Slot {FBFA} ist nicht bereit.\nVorbereiten und Datei erstellen?"                                                       },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3013, .text = "Liest Daten ..."                                                                                                       },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3041, .text = "Lädt Daten ...\nSpiel bitte nicht beenden."                                                                            },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3043, .text = "Slot {FBFA} enthält\nkeine \"Dark Chronicle\"-Daten."                                                                  },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3044, .text = "Slot {FBFA} ist nicht bereit.\nVorbereiten und Datei erstellen?"                                                       },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3046, .text = "Nicht genügend freier Platz."                                                                                          },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3047, .text = "Kein Slot verfügbar."                                                                                                  },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3048, .text = "Bereitet Slot {FBFA} vor ...\nSpiel bitte nicht beenden."                                                              },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3050, .text = "Der Slot ist nicht bereit."                                                                                            },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3051, .text = "Der Slot ist nicht bereit.\nVorbereiten?"                                                                              },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3052, .text = "Slot vorbereiten?"                                                                                                     },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3053, .text = "Slot {FBFA} ist nicht bereit. Bitte einen\nSlot mit 'Dark Chronicle'-Daten wählen."                                    },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3060, .text = "Slot leeren?"                                                                                                          },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3070, .text = "Spielstand speichern?"                                                                                                 },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3100, .text = "Slot wählen."                                                                                                          },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3103, .text = "Slot 1"                                                                                                                },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3104, .text = "Slot 2"                                                                                                                },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3150, .text = "Speichert Extra-Daten.\nSlot wählen.\n   Slot 1\n   Slot 2"                                                            },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3151, .text = "Lädt Extra-Daten.\nSlot wählen.\n   Slot 1\n   Slot 2"                                                                 },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3152, .text = "Nicht genug Platz in Slot {FBFA}.\nMind. {FBF9} KB nötig\nfür neue Extra-Datei."                                       },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3153, .text = "Keine Extra-Daten in\ndiesem Slot gefunden.\n{FBF9} KB freier Speicherplatz\nnötig für neue "
                                                                   "Extra-Datei.\nExtra-Datei jetzt erstellen?"                  },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3154, .text = "Extra-Daten in Slot {FBFA} sind\nu. U. beschädigt. Bitte im\nSpielstand-Ordner löschen."                               },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3158, .text = "Extra-Daten in Slot {FBFA} werden\nüberschrieben. Trotzdem speichern?"                                                 },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3159, .text = "Extra-Daten aus Slot {FBFA} laden?"                                                                                    },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3161, .text = "Keine Extra-Daten in\ndiesem Slot gefunden.\nExtras trotzdem starten?"                                                 },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3162, .text = "Keine Extra-Daten in\ndiesem Slot gefunden."                                                                           },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3164, .text = "Speichert ..."                                                                                                         },
    {.file = MesFile::kAllMenu, .language = 3, .id = 3165, .text = "Lädt ..."                                                                                                              },
    {.file = MesFile::kSysMes,  .language = 3, .id = 100,  .text = "Speichern nicht möglich. Mind. 502 KB\nfreier Speicherplatz sind zum Speichern\nerforderlich. "
                                                                 "Fortfahren,\nohne zu speichern?{TAIL}"                          },
    {.file = MesFile::kSysMes,  .language = 3, .id = 101,  .text = "Nicht genügend Speicherplatz.\nMind. 502 KB freier Speicherplatz\nsind zum Speichern erforderlich. Trotzdem "
                                                                 "fortfahren?{TAIL}"                                              },
    {.file = MesFile::kSysMes,  .language = 3, .id = 102,  .text = "Lädt ..."                                                                                                              },

    // Italian
    {.file = MesFile::kAllMenu, .language = 4, .id = 153,  .text = "Puoi portare solo {FBFA} \"{FAF9}\".\nPremi {FD07} per rimuoverli o\nusa il comando \"Getta\"."                        },
    {.file = MesFile::kAllMenu, .language = 4, .id = 670,  .text = "Visualizzare Album?"                                                                                                   },
    {.file = MesFile::kAllMenu, .language = 4, .id = 671,  .text = "Nessun dato Album trovato."                                                                                            },
    {.file = MesFile::kAllMenu, .language = 4, .id = 673,  .text = "Salvare Album?"                                                                                                        },
    {.file = MesFile::kAllMenu, .language = 4, .id = 678,  .text = "Questo Album\nnon contiene dati.\nCreare un nuovo Album?"                                                              },
    {.file = MesFile::kAllMenu, .language = 4, .id = 679,  .text = "Per creare un Album sono necessari\n490KB di spazio libero."                                                           },
    {.file = MesFile::kAllMenu, .language = 4, .id = 684,  .text = "Seleziona un Album.\n   Album 1\n   Album 2"                                                                           },
    {.file = MesFile::kAllMenu, .language = 4, .id = 687,  .text = "Salvataggio Album in corso..."                                                                                         },
    {.file = MesFile::kAllMenu, .language = 4, .id = 689,  .text = "Dati Album non trovati\nin questo Album.\nPer i dati Album sono necessari\n490KB di spazio libero.\nCreare un "
                                                                  "Album?"                                                        },
    {.file = MesFile::kAllMenu, .language = 4, .id = 691,  .text = "Questo Album non è pronto.\nPrepararlo ora?"                                                                           },
    {.file = MesFile::kAllMenu, .language = 4, .id = 692,  .text = "Per salvare i dati dell'Album,\nseleziona dove salvarli.\n   Album 1\n   Album 2"                                      },
    {.file = MesFile::kAllMenu, .language = 4, .id = 693,  .text = "Questo Album\nnon contiene dati."                                                                                      },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3000, .text = "Quale slot vuoi usare?\n   Slot 1\n   Slot 2"                                                                          },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3001, .text = "Lo slot {FBFA} non è disponibile."                                                                                     },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3002, .text = "Impossibile leggere lo slot {FBFA}."                                                                                   },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3003, .text = "Lettura in corso..."                                                                                                   },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3004, .text = "Spazio libero insufficiente\nnello slot {FBFA}.\nPer un file nuovo sono necessari\nalmeno {FBF9}KB."                   },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3005, .text = "Impossibile leggere lo slot {FBFA}."                                                                                   },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3007, .text = "Salvataggio in corso...\nNon chiudere il gioco."                                                                       },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3010, .text = "Lo slot {FBFA} non è pronto.\nPrepararlo e creare un nuovo file?"                                                      },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3013, .text = "Lettura dati in corso..."                                                                                              },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3041, .text = "Caricamento dati in corso...\nNon chiudere il gioco."                                                                  },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3043, .text = "Lo slot {FBFA} non contiene\ndati di Dark Chronicle."                                                                  },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3044, .text = "Lo slot {FBFA} non è pronto.\nPrepararlo e creare un nuovo file?"                                                      },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3046, .text = "Spazio libero insufficiente."                                                                                          },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3047, .text = "Nessuno slot disponibile."                                                                                             },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3048, .text = "Preparazione dello slot {FBFA} in corso...\nNon chiudere il gioco."                                                    },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3050, .text = "Lo slot non è pronto."                                                                                                 },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3051, .text = "Lo slot non è pronto.\nPrepararlo?"                                                                                    },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3052, .text = "Preparare lo slot?"                                                                                                    },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3053, .text = "Lo slot {FBFA} non è pronto.\nScegli uno slot che contenga\nun file salvato di Dark Chronicle."                        },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3060, .text = "Svuotare lo slot?"                                                                                                     },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3070, .text = "Salvare il gioco?"                                                                                                     },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3100, .text = "Seleziona uno slot."                                                                                                   },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3103, .text = "Slot 1"                                                                                                                },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3104, .text = "Slot 2"                                                                                                                },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3150, .text = "Salva dati Extra.\nScegli.\n   Slot 1\n   Slot 2"                                                                      },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3151, .text = "Carica dati Extra.\nScegli:\n   Slot 1\n   Slot 2"                                                                     },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3152, .text = "Lo slot {FBFA} non ha spazio libero sufficiente.\nPer un nuovo file Extra sono\nnecessari almeno {FBF9}KB."            },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3153, .text = "In questo slot non è\nstato trovato alcun dato Extra.\nPer creare un nuovo file Extra\nservono almeno "
                                                                   "{FBF9}KB\ndi spazio libero.\nCreare un nuovo file Extra ora?"},
    {.file = MesFile::kAllMenu, .language = 4, .id = 3154, .text = "I dati Extra nello slot {FBFA}\npotrebbero essere danneggiati.\nCancellali dalla cartella dei salvataggi."             },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3158, .text = "I dati Extra nello slot {FBFA}\nverranno sovrascritti.\nSalvare comunque?"                                             },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3159, .text = "Caricare i dati Extra dallo slot {FBFA}?"                                                                              },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3161, .text = "Nessun dato Extra trovato\nin questo slot.\nAvviare Extra comunque?"                                                   },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3162, .text = "Nessun dato Extra trovato\nin questo slot."                                                                            },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3164, .text = "Salvataggio in corso..."                                                                                               },
    {.file = MesFile::kAllMenu, .language = 4, .id = 3165, .text = "Caricamento in corso..."                                                                                               },
    {.file = MesFile::kSysMes,  .language = 4, .id = 100,  .text = "Impossibile salvare. Per salvare i dati\ndi gioco occorrono almeno 502 KB\ndi spazio libero. Continuare senza "
                                                                 "salvare?{TAIL}"                                                 },
    {.file = MesFile::kSysMes,  .language = 4, .id = 101,  .text = "Spazio insufficiente per salvare.\nOccorrono almeno 502 KB per salvare\ni dati di gioco. Continuare "
                                                                 "ugualmente?{TAIL}"                                              },
    {.file = MesFile::kSysMes,  .language = 4, .id = 102,  .text = "Caricamento..."                                                                                                        },

    // Spanish
    {.file = MesFile::kAllMenu, .language = 5, .id = 153,  .text = "Sólo puedes llevar {FBFA} \"{FAF9}\".\nPulsa {FD07} para moverlos o\nusa el botón \"Eliminar\"."                       },
    {.file = MesFile::kAllMenu, .language = 5, .id = 670,  .text = "¿Ver Álbum?"                                                                                                           },
    {.file = MesFile::kAllMenu, .language = 5, .id = 671,  .text = "No hay datos del Álbum."                                                                                               },
    {.file = MesFile::kAllMenu, .language = 5, .id = 673,  .text = "¿Guardar el Álbum actual?"                                                                                             },
    {.file = MesFile::kAllMenu, .language = 5, .id = 678,  .text = "No hay datos guardados\nen este Álbum.\n¿Crear un Álbum nuevo?"                                                        },
    {.file = MesFile::kAllMenu, .language = 5, .id = 679,  .text = "No hay espacio suficiente\npara guardar un Álbum (490 KB)."                                                            },
    {.file = MesFile::kAllMenu, .language = 5, .id = 684,  .text = "Selecciona un Álbum.\n   Álbum 1\n   Álbum 2"                                                                          },
    {.file = MesFile::kAllMenu, .language = 5, .id = 687,  .text = "Guardando el Álbum..."                                                                                                 },
    {.file = MesFile::kAllMenu, .language = 5, .id = 689,  .text = "No hay datos guardados\nen este Álbum.\nSe necesitan 490 KB de espacio\nlibre para guardar el "
                                                                  "Álbum.\n¿Guardar Álbum?"                                       },
    {.file = MesFile::kAllMenu, .language = 5, .id = 691,  .text = "Este Álbum no está preparado.\n¿Quieres prepararlo?"                                                                   },
    {.file = MesFile::kAllMenu, .language = 5, .id = 692,  .text = "Selecciona dónde guardar\nlos datos del Álbum:\n  Álbum 1\n  Álbum 2"                                                  },
    {.file = MesFile::kAllMenu, .language = 5, .id = 693,  .text = "No hay datos guardados\nen este Álbum."                                                                                },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3000, .text = "¿Qué ranura quieres usar?\n  Ranura 1\n  Ranura 2"                                                                     },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3001, .text = "La ranura {FBFA} no está disponible."                                                                                  },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3002, .text = "¡Error al leer la ranura {FBFA}!"                                                                                      },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3003, .text = "Comprobando datos..."                                                                                                  },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3004, .text = "No hay espacio suficiente en la ranura {FBFA}.\nNecesitas al menos {FBF9} KB para guardar datos."                      },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3005, .text = "¡Error al leer la ranura {FBFA}!"                                                                                      },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3007, .text = "Guardando datos.\nNo cierres el juego."                                                                                },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3010, .text = "La ranura {FBFA} no está preparada.\n¿Quieres prepararla?"                                                             },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3013, .text = "Leyendo datos..."                                                                                                      },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3041, .text = "Cargando datos.\nNo cierres el juego."                                                                                 },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3043, .text = "No hay datos guardados de Dark Chronicle\nen la ranura {FBFA}."                                                        },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3044, .text = "La ranura {FBFA} no está preparada.\n¿Quieres prepararla?"                                                             },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3046, .text = "No hay espacio suficiente."                                                                                            },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3047, .text = "No hay ninguna ranura disponible."                                                                                     },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3048, .text = "Preparando la ranura {FBFA}.\nNo cierres el juego."                                                                    },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3050, .text = "La ranura no está preparada."                                                                                          },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3051, .text = "La ranura no está preparada.\n¿Quieres prepararla?"                                                                    },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3052, .text = "¿Preparar la ranura?"                                                                                                  },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3053, .text = "La ranura {FBFA} no está preparada.\nElige una ranura con una partida\nguardada de Dark Chronicle."                    },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3060, .text = "¿Vaciar la ranura?"                                                                                                    },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3070, .text = "¿Guardar datos?"                                                                                                       },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3100, .text = "Selecciona una ranura."                                                                                                },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3103, .text = "Ranura 1"                                                                                                              },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3104, .text = "Ranura 2"                                                                                                              },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3150, .text = "Guarda los Extras.\nSelecciona una ranura.\n   Ranura 1\n   Ranura 2"                                                  },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3151, .text = "Carga los Extras.\nSelecciona una ranura.\n   Ranura 1\n   Ranura 2"                                                   },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3152, .text = "No hay espacio suficiente en la ranura {FBFA}.\nNecesitas al menos {FBF9} KB\npara guardar los Extras."                },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3153, .text = "No hay datos guardados de Extras\nen esta ranura.\nNecesitas {FBF9} KB de espacio libre\npara guardar nuevos "
                                                                   "Extras.\n¿Guardar los Extras ahora?"                         },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3154, .text = "Los Extras de la ranura {FBFA}\npueden estar dañados.\nBórralos de la carpeta de partidas."                            },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3158, .text = "Se sobrescribirán los Extras\nde la ranura {FBFA}.\n¿Guardar de todos modos?"                                          },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3159, .text = "¿Cargar Extras de la ranura {FBFA}?"                                                                                   },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3161, .text = "No hay datos guardados de Extras\nen esta ranura.\n¿Comenzar Extras de todos modos?"                                   },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3162, .text = "No hay datos guardados de Extras\nen esta ranura."                                                                     },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3164, .text = "Guardando datos..."                                                                                                    },
    {.file = MesFile::kAllMenu, .language = 5, .id = 3165, .text = "Cargando datos..."                                                                                                     },
    {.file = MesFile::kSysMes,  .language = 5, .id = 100,  .text = "No se pueden guardar datos.\nSe necesitan al menos 502 KB de espacio libre.\n¿Continuar sin guardar?{TAIL}"            },
    {.file = MesFile::kSysMes,  .language = 5, .id = 101,  .text = "No hay espacio suficiente para guardar.\nSe necesitan al menos 502 KB de espacio libre.\n¿Continuar de todas "
                                                                 "formas?{TAIL}"                                                  },
    {.file = MesFile::kSysMes,  .language = 5, .id = 102,  .text = "Cargando..."                                                                                                           },
};

// Messages the disc does not have, by LanguageCode, found in whichever message file is asked for the number: the quick
// loadout's "Equip Slot" item command and its four slots (quick_loadout_menu.cpp), which the command list reads from
// meswin/system_<language>.mes. {FD07} is Triangle and {FD09} Square; PAL draws {FD06} as Cross and {FD08} as Circle.
struct Addition {
    int              language;
    int              id;
    std::string_view text;
};

constexpr Addition kAdditions[] = {
    {.language = 1, .id = 5090, .text = "Equip Slot"         },
    {.language = 1, .id = 5091, .text = "{FD07} Triangle"    },
    {.language = 1, .id = 5092, .text = "{FD09} Square"      },
    {.language = 1, .id = 5093, .text = "{FD06} Cross"       },
    {.language = 1, .id = 5094, .text = "{FD08} Circle"      },
    {.language = 2, .id = 5090, .text = "Équiper emplacement"},
    {.language = 2, .id = 5091, .text = "{FD07} Triangle"    },
    {.language = 2, .id = 5092, .text = "{FD09} Carré"       },
    {.language = 2, .id = 5093, .text = "{FD06} Croix"       },
    {.language = 2, .id = 5094, .text = "{FD08} Rond"        },
    {.language = 3, .id = 5090, .text = "Platz belegen"      },
    {.language = 3, .id = 5091, .text = "{FD07} Dreieck"     },
    {.language = 3, .id = 5092, .text = "{FD09} Quadrat"     },
    {.language = 3, .id = 5093, .text = "{FD06} Kreuz"       },
    {.language = 3, .id = 5094, .text = "{FD08} Kreis"       },
    {.language = 4, .id = 5090, .text = "Equipaggia slot"    },
    {.language = 4, .id = 5091, .text = "{FD07} Triangolo"   },
    {.language = 4, .id = 5092, .text = "{FD09} Quadrato"    },
    {.language = 4, .id = 5093, .text = "{FD06} Croce"       },
    {.language = 4, .id = 5094, .text = "{FD08} Cerchio"     },
    {.language = 5, .id = 5090, .text = "Equipar hueco"      },
    {.language = 5, .id = 5091, .text = "{FD07} Triángulo"   },
    {.language = 5, .id = 5092, .text = "{FD09} Cuadrado"    },
    {.language = 5, .id = 5093, .text = "{FD06} Equis"       },
    {.language = 5, .id = 5094, .text = "{FD08} Círculo"     },
};

constexpr std::uint16_t kCodeNewline = 0xFF00;
constexpr std::uint16_t kCodeEnd = 0xFF01;
constexpr std::uint16_t kCodeSpace = 0xFF02;

// The retail lookup, as ClsMes::GetTextLineDataTop does it.
u16 *FindLine(short *table, int line_id) {
    if (table == nullptr) {
        return nullptr;
    }
    const int count = *table;
    short    *entries = table + 1;
    for (int i = 0; i < count; i++) {
        if (std::cmp_equal(line_id, entries[i * 2 + 1])) {
            return reinterpret_cast<u16 *>(entries + count + static_cast<u16>(entries[i * 2 + 2]));
        }
    }
    return nullptr;
}

const KnownFile *Identify(const short *table) {
    for (const auto &known : kKnownFiles) {
        if (static_cast<u16>(table[0]) == known.count && static_cast<u16>(table[1]) == known.word1) {
            return &known;
        }
    }
    return nullptr;
}

// Half-width glyphs follow ASCII from the space, with no backslash; Latin-1 letters use 0xFF00 + the code point.
void Append(std::vector<std::uint16_t> &out, char32_t ch) {
    if (ch == '\n') {
        out.push_back(kCodeNewline);
    } else if (ch == ' ') {
        out.push_back(kCodeSpace);
    } else if (ch > 0x20 && ch < 0x5C) {
        out.push_back(static_cast<std::uint16_t>(ch - 0x20));
    } else if (ch > 0x5C && ch < 0x7F) {
        out.push_back(static_cast<std::uint16_t>(ch - 0x21));
    } else if (ch >= 0xA0 && ch <= 0xFF) {
        out.push_back(static_cast<std::uint16_t>(0xFF00 | ch));
    }
}

std::vector<std::uint16_t> Encode(std::string_view text, const u16 *original) {
    std::vector<std::uint16_t> out;
    for (std::size_t i = 0; i < text.size();) {
        if (text[i] == '{') {
            const auto close = text.find('}', i);
            const auto token = text.substr(i + 1, close - i - 1);
            if (token == "TAIL") {
                const u16 *tail = nullptr;
                for (const u16 *code = original; code && *code != kCodeEnd; ++code) {
                    if (*code == kCodeNewline) {
                        tail = code;
                    }
                }
                for (; tail && *tail != kCodeEnd; ++tail) {
                    out.push_back(*tail);
                }
            } else {
                std::uint16_t code = 0;
                for (char digit : token) {
                    code = static_cast<std::uint16_t>(code * 16 + (digit <= '9' ? digit - '0' : digit - 'A' + 10));
                }
                out.push_back(code);
            }
            i = close + 1;
            continue;
        }
        const auto  lead = static_cast<unsigned char>(text[i]);
        char32_t    ch = lead;
        std::size_t length = 1;
        if (lead >= 0xC0 && lead < 0xE0 && i + 1 < text.size()) {
            ch = ((lead & 0x1F) << 6) | (static_cast<unsigned char>(text[i + 1]) & 0x3F);
            length = 2;
        }
        Append(out, ch);
        i += length;
    }
    out.push_back(kCodeEnd);
    return out;
}

u16 *Added(int line_id) {
    static std::map<std::pair<int, int>, std::vector<std::uint16_t> > encoded;
    const auto                                                        key = std::make_pair(LanguageCode, line_id);
    if (auto found = encoded.find(key); found != encoded.end()) {
        return reinterpret_cast<u16 *>(found->second.data());
    }
    for (const auto &addition : kAdditions) {
        if (addition.language == LanguageCode && addition.id == line_id) {
            auto &codes = encoded[key] = Encode(addition.text, nullptr);
            return reinterpret_cast<u16 *>(codes.data());
        }
    }
    return nullptr;
}

u16 *Lookup(short *table, int line_id) {
    u16 *original = FindLine(table, line_id);
    if (table == nullptr) {
        return original;
    }
    if (original == nullptr) {
        return Added(line_id);
    }
    const KnownFile *known = Identify(table);
    if (!known) {
        return original;
    }
    static std::map<std::tuple<MesFile, int, int>, std::vector<std::uint16_t> > encoded;
    const auto                                                                  key = std::make_tuple(known->file, known->language, line_id);
    if (auto found = encoded.find(key); found != encoded.end()) {
        return reinterpret_cast<u16 *>(found->second.data());
    }
    for (const auto &replacement : kReplacements) {
        if (replacement.file == known->file && replacement.language == known->language && replacement.id == line_id) {
            auto &codes = encoded[key] = Encode(replacement.text, original);
            return reinterpret_cast<u16 *>(codes.data());
        }
    }
    return original;
}

} // namespace

PORT_OVERRIDE u16 *ClsMes::GetTextLineDataTop(int line_id) {
    return Lookup(buff, line_id);
}

PORT_OVERRIDE u16 *ClsMes::GetTextLineDataTop_system(int line_id) {
    return Lookup(buff_system, line_id);
}
