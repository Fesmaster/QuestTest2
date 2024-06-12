 
workspace("QTS_Native")
configurations({ "Debug","Release" })
platforms { "Win64", "Linux" }


project("QTSCommon")
    kind("SharedLib")
    pic("On")
    language("C++")
    targetdir("bin/%{cfg.buildcfg}")
    files({ 
        "src/QTSCommonLib/**.h", 
        "src/QTSCommonLib/**.hpp", 
        "src/QTSCommonLib/**.c", 
        "src/QTSCommonLib/**.cpp" 
    })

    includedirs({ 
        "thridparty", 
        "src/QTSCommonLib",  
    })
    
    links({
        "GL"
    })

    filter("configurations:Debug")
        defines({ "DEBUG" })
        symbols("On")
    
    filter("configurations:Release")
        defines({ "NDEBUG" })
        optimize("On")

    filter("")

    filter("platforms:Win64")
        defines({ "QTS_WINDOWS" })
        system("windows")
    
    filter("platforms:Linux")
        defines({ "QTS_LINUX" })
        system("linux")
        links({"X11"})
        buildoptions({ "-fPIC" })
        linkoptions({"-fPIC"})
        --toolset ("clang")

    filter("")

