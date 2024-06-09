
#include "QTSCommon.h"

#ifdef QTS_LINUX

#include <X11/Xlib.h>
#include <X11/keysym.h>

bool LinuxKeymap::bInitalized = false;
std::unordered_map<int, int> LinuxKeymap::LinuxToMinetest;
std::unordered_map<int, int> LinuxKeymap::MinetestToLinux;

#endif // QTS_LINUX

//#include <stdbool.h>
//#include <stdio.h>




extern "C" {

#ifdef QTS_LINUX
bool IsKeyPressed(int Code)
{
    LinuxKeymap::Initialize();
    Display* dpy = XOpenDisplay(NULL);
    char keys_return[32];
    XQueryKeymap( dpy, keys_return );
    KeyCode kc2 = XKeysymToKeycode( dpy, LinuxKeymap::GetLinuxKeyFromMinetestKey(Code) );
    bool bKeyPressed = !!( keys_return[ kc2>>3 ] & ( 1<<(kc2&7) ) );
    XCloseDisplay(dpy);
    return bKeyPressed;

}
#endif // QTS_LINUX

}

#ifdef QTS_LINUX

void LinuxKeymap::Initialize()
{
    if (LinuxKeymap::bInitalized)
    {
        return;
    }

    InitKeyPair(XK_BackSpace, KEY_BACK);
	InitKeyPair(XK_Tab, KEY_TAB);
	InitKeyPair(XK_ISO_Left_Tab, KEY_TAB);
	//InitKeyPair(XK_Linefeed, 0); // ???
	InitKeyPair(XK_Clear, KEY_CLEAR);
	InitKeyPair(XK_Return, KEY_RETURN);
	InitKeyPair(XK_Pause, KEY_PAUSE);
	InitKeyPair(XK_Scroll_Lock, KEY_SCROLL);
	//InitKeyPair(XK_Sys_Req, 0); // ???
	InitKeyPair(XK_Escape, KEY_ESCAPE);
	InitKeyPair(XK_Insert, KEY_INSERT);
	InitKeyPair(XK_Delete, KEY_DELETE);
	InitKeyPair(XK_Home, KEY_HOME);
	InitKeyPair(XK_Left, KEY_LEFT);
	InitKeyPair(XK_Up, KEY_UP);
	InitKeyPair(XK_Right, KEY_RIGHT);
	InitKeyPair(XK_Down, KEY_DOWN);
	InitKeyPair(XK_Prior, KEY_PRIOR);
	InitKeyPair(XK_Page_Up, KEY_PRIOR);
	InitKeyPair(XK_Next, KEY_NEXT);
	InitKeyPair(XK_Page_Down, KEY_NEXT);
	InitKeyPair(XK_End, KEY_END);
	InitKeyPair(XK_Begin, KEY_HOME);
	InitKeyPair(XK_Num_Lock, KEY_NUMLOCK);
	InitKeyPair(XK_KP_Space, KEY_SPACE);
	InitKeyPair(XK_KP_Tab, KEY_TAB);
	InitKeyPair(XK_KP_Enter, KEY_RETURN);
	InitKeyPair(XK_KP_F1, KEY_F1);
	InitKeyPair(XK_KP_F2, KEY_F2);
	InitKeyPair(XK_KP_F3, KEY_F3);
	InitKeyPair(XK_KP_F4, KEY_F4);
	InitKeyPair(XK_KP_Home, KEY_HOME);
	InitKeyPair(XK_KP_Left, KEY_LEFT);
	InitKeyPair(XK_KP_Up, KEY_UP);
	InitKeyPair(XK_KP_Right, KEY_RIGHT);
	InitKeyPair(XK_KP_Down, KEY_DOWN);
	InitKeyPair(XK_Print, KEY_PRINT);
	InitKeyPair(XK_KP_Prior, KEY_PRIOR);
	InitKeyPair(XK_KP_Page_Up, KEY_PRIOR);
	InitKeyPair(XK_KP_Next, KEY_NEXT);
	InitKeyPair(XK_KP_Page_Down, KEY_NEXT);
	InitKeyPair(XK_KP_End, KEY_END);
	InitKeyPair(XK_KP_Begin, KEY_HOME);
	InitKeyPair(XK_KP_Insert, KEY_INSERT);
	InitKeyPair(XK_KP_Delete, KEY_DELETE);
	//InitKeyPair(XK_KP_Equal, 0); // ???
	InitKeyPair(XK_KP_Multiply, KEY_MULTIPLY);
	InitKeyPair(XK_KP_Add, KEY_ADD);
	InitKeyPair(XK_KP_Separator, KEY_SEPARATOR);
	InitKeyPair(XK_KP_Subtract, KEY_SUBTRACT);
	InitKeyPair(XK_KP_Decimal, KEY_DECIMAL);
	InitKeyPair(XK_KP_Divide, KEY_DIVIDE);
	InitKeyPair(XK_KP_0, KEY_NUMPAD0);
	InitKeyPair(XK_KP_1, KEY_NUMPAD1);
	InitKeyPair(XK_KP_2, KEY_NUMPAD2);
	InitKeyPair(XK_KP_3, KEY_NUMPAD3);
	InitKeyPair(XK_KP_4, KEY_NUMPAD4);
	InitKeyPair(XK_KP_5, KEY_NUMPAD5);
	InitKeyPair(XK_KP_6, KEY_NUMPAD6);
	InitKeyPair(XK_KP_7, KEY_NUMPAD7);
	InitKeyPair(XK_KP_8, KEY_NUMPAD8);
	InitKeyPair(XK_KP_9, KEY_NUMPAD9);
	InitKeyPair(XK_F1, KEY_F1);
	InitKeyPair(XK_F2, KEY_F2);
	InitKeyPair(XK_F3, KEY_F3);
	InitKeyPair(XK_F4, KEY_F4);
	InitKeyPair(XK_F5, KEY_F5);
	InitKeyPair(XK_F6, KEY_F6);
	InitKeyPair(XK_F7, KEY_F7);
	InitKeyPair(XK_F8, KEY_F8);
	InitKeyPair(XK_F9, KEY_F9);
	InitKeyPair(XK_F10, KEY_F10);
	InitKeyPair(XK_F11, KEY_F11);
	InitKeyPair(XK_F12, KEY_F12);
	InitKeyPair(XK_Shift_L, KEY_LSHIFT);
	InitKeyPair(XK_Shift_R, KEY_RSHIFT);
	InitKeyPair(XK_Control_L, KEY_LCONTROL);
	InitKeyPair(XK_Control_R, KEY_RCONTROL);
	InitKeyPair(XK_Caps_Lock, KEY_CAPITAL);
	InitKeyPair(XK_Shift_Lock, KEY_CAPITAL);
	InitKeyPair(XK_Meta_L, KEY_LWIN);
	InitKeyPair(XK_Meta_R, KEY_RWIN);
	InitKeyPair(XK_Alt_L, KEY_LMENU);
	InitKeyPair(XK_Alt_R, KEY_RMENU);
	InitKeyPair(XK_ISO_Level3_Shift, KEY_RMENU);
	InitKeyPair(XK_Menu, KEY_MENU);
	InitKeyPair(XK_space, KEY_SPACE);
	//InitKeyPair(XK_exclam, 0); //?
	//InitKeyPair(XK_quotedbl, 0); //?
	//InitKeyPair(XK_section, 0); //?
	InitKeyPair(XK_numbersign, KEY_OEM_2);
	//InitKeyPair(XK_dollar, 0); //?
	//InitKeyPair(XK_percent, 0); //?
	//InitKeyPair(XK_ampersand, 0); //?
	InitKeyPair(XK_apostrophe, KEY_OEM_7);
	//InitKeyPair(XK_parenleft, 0); //?
	//InitKeyPair(XK_parenright, 0); //?
	//InitKeyPair(XK_asterisk, 0); //?
	InitKeyPair(XK_plus, KEY_PLUS); //?
	InitKeyPair(XK_comma, KEY_COMMA); //?
	InitKeyPair(XK_minus, KEY_MINUS); //?
	InitKeyPair(XK_period, KEY_PERIOD); //?
	InitKeyPair(XK_slash, KEY_OEM_2); //?
	InitKeyPair(XK_0, KEY_KEY_0);
	InitKeyPair(XK_1, KEY_KEY_1);
	InitKeyPair(XK_2, KEY_KEY_2);
	InitKeyPair(XK_3, KEY_KEY_3);
	InitKeyPair(XK_4, KEY_KEY_4);
	InitKeyPair(XK_5, KEY_KEY_5);
	InitKeyPair(XK_6, KEY_KEY_6);
	InitKeyPair(XK_7, KEY_KEY_7);
	InitKeyPair(XK_8, KEY_KEY_8);
	InitKeyPair(XK_9, KEY_KEY_9);
	//InitKeyPair(XK_colon, 0); //?
	InitKeyPair(XK_semicolon, KEY_OEM_1);
	InitKeyPair(XK_less, KEY_OEM_102);
	InitKeyPair(XK_equal, KEY_PLUS);
	//InitKeyPair(XK_greater, 0); //?
	//InitKeyPair(XK_question, 0); //?
	InitKeyPair(XK_at, KEY_KEY_2); //?
	//InitKeyPair(XK_mu, 0); //?
	//InitKeyPair(XK_EuroSign, 0); //?
	InitKeyPair(XK_A, KEY_KEY_A);
	InitKeyPair(XK_B, KEY_KEY_B);
	InitKeyPair(XK_C, KEY_KEY_C);
	InitKeyPair(XK_D, KEY_KEY_D);
	InitKeyPair(XK_E, KEY_KEY_E);
	InitKeyPair(XK_F, KEY_KEY_F);
	InitKeyPair(XK_G, KEY_KEY_G);
	InitKeyPair(XK_H, KEY_KEY_H);
	InitKeyPair(XK_I, KEY_KEY_I);
	InitKeyPair(XK_J, KEY_KEY_J);
	InitKeyPair(XK_K, KEY_KEY_K);
	InitKeyPair(XK_L, KEY_KEY_L);
	InitKeyPair(XK_M, KEY_KEY_M);
	InitKeyPair(XK_N, KEY_KEY_N);
	InitKeyPair(XK_O, KEY_KEY_O);
	InitKeyPair(XK_P, KEY_KEY_P);
	InitKeyPair(XK_Q, KEY_KEY_Q);
	InitKeyPair(XK_R, KEY_KEY_R);
	InitKeyPair(XK_S, KEY_KEY_S);
	InitKeyPair(XK_T, KEY_KEY_T);
	InitKeyPair(XK_U, KEY_KEY_U);
	InitKeyPair(XK_V, KEY_KEY_V);
	InitKeyPair(XK_W, KEY_KEY_W);
	InitKeyPair(XK_X, KEY_KEY_X);
	InitKeyPair(XK_Y, KEY_KEY_Y);
	InitKeyPair(XK_Z, KEY_KEY_Z);
	InitKeyPair(XK_bracketleft, KEY_OEM_4);
	InitKeyPair(XK_backslash, KEY_OEM_5);
	InitKeyPair(XK_bracketright, KEY_OEM_6);
	InitKeyPair(XK_asciicircum, KEY_OEM_5);
	InitKeyPair(XK_dead_circumflex, KEY_OEM_5);
	//InitKeyPair(XK_degree, 0); //?
	InitKeyPair(XK_underscore, KEY_MINUS); //?
	InitKeyPair(XK_grave, KEY_OEM_3);
	InitKeyPair(XK_dead_grave, KEY_OEM_3);
	InitKeyPair(XK_acute, KEY_OEM_6);
	InitKeyPair(XK_dead_acute, KEY_OEM_6);
	InitKeyPair(XK_a, KEY_KEY_A);
	InitKeyPair(XK_b, KEY_KEY_B);
	InitKeyPair(XK_c, KEY_KEY_C);
	InitKeyPair(XK_d, KEY_KEY_D);
	InitKeyPair(XK_e, KEY_KEY_E);
	InitKeyPair(XK_f, KEY_KEY_F);
	InitKeyPair(XK_g, KEY_KEY_G);
	InitKeyPair(XK_h, KEY_KEY_H);
	InitKeyPair(XK_i, KEY_KEY_I);
	InitKeyPair(XK_j, KEY_KEY_J);
	InitKeyPair(XK_k, KEY_KEY_K);
	InitKeyPair(XK_l, KEY_KEY_L);
	InitKeyPair(XK_m, KEY_KEY_M);
	InitKeyPair(XK_n, KEY_KEY_N);
	InitKeyPair(XK_o, KEY_KEY_O);
	InitKeyPair(XK_p, KEY_KEY_P);
	InitKeyPair(XK_q, KEY_KEY_Q);
	InitKeyPair(XK_r, KEY_KEY_R);
	InitKeyPair(XK_s, KEY_KEY_S);
	InitKeyPair(XK_t, KEY_KEY_T);
	InitKeyPair(XK_u, KEY_KEY_U);
	InitKeyPair(XK_v, KEY_KEY_V);
	InitKeyPair(XK_w, KEY_KEY_W);
	InitKeyPair(XK_x, KEY_KEY_X);
	InitKeyPair(XK_y, KEY_KEY_Y);
	InitKeyPair(XK_z, KEY_KEY_Z);
	InitKeyPair(XK_ssharp, KEY_OEM_4);
	InitKeyPair(XK_adiaeresis, KEY_OEM_7);
	InitKeyPair(XK_odiaeresis, KEY_OEM_3);
	InitKeyPair(XK_udiaeresis, KEY_OEM_1);
	InitKeyPair(XK_Super_L, KEY_LWIN);
	InitKeyPair(XK_Super_R, KEY_RWIN);


}

void LinuxKeymap::InitKeyPair(int LinuxKey, int MinetestKey)
{
    LinuxKeymap::LinuxToMinetest[LinuxKey] = MinetestKey;
    LinuxKeymap::MinetestToLinux[MinetestKey] = LinuxKey;
}

int LinuxKeymap::GetLinuxKeyFromMinetestKey(int Key)
{
    auto it = LinuxKeymap::MinetestToLinux.find(Key);
    if (it != LinuxKeymap::MinetestToLinux.end())
    {
        return it->second;
    }
    return 0;
}

int LinuxKeymap::GetMinetestKeyFromLinuxKey(int Key)
{
    auto it = LinuxKeymap::LinuxToMinetest.find(Key);
    if (it != LinuxKeymap::LinuxToMinetest.end())
    {
        return it->second;
    }
    return 0;
}

#endif //QTS_LINUX

