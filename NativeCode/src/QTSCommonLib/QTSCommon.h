#include <unordered_map>
#include <vector>


#include "QTSPlatform.h"
#include "KeyCode.h"

extern "C" {
	EXPORT void ModuleStartup();

	EXPORT void ModuleShutdown();

#ifdef QTS_LINUX
    EXPORT bool IsKeyPressed(int KeyCode);
#endif //QTS_LINUX
};

// Helper stuff - not exported


#ifdef QTS_LINUX

class LinuxKeymap
{
public:
    static void Initialize();
    
    static std::vector<int> GetLinuxKeyFromMinetestKey(EKeyCode::Type Key);

    static std::vector<EKeyCode::Type> GetMinetestKeyFromLinuxKey(int Key);

    static bool IsKeyActuallyMouse(EKeyCode::Type Key);

    static unsigned int GetKeyMouseBit(EKeyCode::Type Key);

private:
    static void InitKeyPair(int LinuxKey, EKeyCode::Type MinetestKey);

    static bool bInitalized;
    static std::unordered_map<int, std::vector<EKeyCode::Type>> LinuxToMinetest;
    static std::unordered_map<EKeyCode::Type, std::vector<int>> MinetestToLinux;
};

#endif //QTS_LINUX

