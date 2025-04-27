/*
 * Key Codes Enum and classes
 */

#include <string>

namespace EKeyCode {
    
    #define ENUM_ENTRY(name, value, desc) name = value,
    enum Type {
        #include "KeyCode.inl"
    };
    #undef ENUM_ENTRY

    #define ENUM_ENTRY(name, value, desc) case (value): return #name;
    inline std::string GetName(EKeyCode::Type Value)
    {
        switch (Value)
        {
            #include "KeyCode.inl"
            default: return "";
        }
    }
    #undef ENUM_ENTRY

    #define ENUM_ENTRY(name, value, desc) case (value): return desc;
    inline std::string GetDesc(EKeyCode::Type Value)
    {
        switch (Value)
        {
            #include "KeyCode.inl"
            default: return "";
        }
    }
    #undef ENUM_ENTRY
};