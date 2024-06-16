#include "QTSRenderer.h"

#ifdef QTS_LINUX
#include "X11/Xutil.h"
#include "GL/gl.h"
#include "GL/glx.h"
#endif // QTS_LINUX


#include <iostream>

extern "C" {

void CheckOpenGLCompat()
{
#ifdef QTS_LINUX

    GLXContext glContext = glXGetCurrentContext();
    if (glContext)
    {
        std::cout << "GL Context found (YAY!)" << std::endl;
    }
    else
    {
        std::cout << "GL Context not found!" << std::endl;
    }

#elif defined(QTS_WINDOWS)

#endif // QTS_LINUX || QTS_WINDOWS
}

}
