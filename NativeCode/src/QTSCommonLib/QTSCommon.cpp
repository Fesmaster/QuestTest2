
#include "QTSCommon.h"

#include <iostream>
#include <thread>
#include <vector>
#include <atomic>
#include <mutex>


#ifdef QTS_LINUX

#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <X11/XKBlib.h>


bool LinuxKeymap::bInitalized = false;
std::unordered_map<int, std::vector<EKeyCode::Type>> LinuxKeymap::LinuxToMinetest;
std::unordered_map<EKeyCode::Type, std::vector<int>> LinuxKeymap::MinetestToLinux;

static Display* GDisplay = nullptr;

#endif // QTS_LINUX


extern "C" {

void ModuleStartup()
{
	std::cout << "QTS Native Code Module Startup" << std::endl;
#ifdef QTS_LINUX
    GDisplay = XOpenDisplay(NULL);
	LinuxKeymap::Initialize();
#endif // QTS_LINUX

}

void ModuleShutdown()
{
#ifdef QTS_LINUX
	if (GDisplay)
	{
    	XCloseDisplay(GDisplay);
		GDisplay = nullptr;
	}
#endif // QTS_LINUX
	std::cout << "QTS Native Code Module Shutdown" << std::endl;
}

#ifdef QTS_LINUX
bool IsKeyPressed(int Code)
{
	if (GDisplay)
	{
		EKeyCode::Type Key = (EKeyCode::Type)Code;
		if (LinuxKeymap::IsKeyActuallyMouse(Key))
		{
			
  			Window root, child;
  			int rootX, rootY, winX, winY;
  			unsigned int mask;

  			XQueryPointer(GDisplay,DefaultRootWindow(GDisplay), &root, &child, &rootX, &rootY, &winX, &winY, &mask);

			return !!(mask & LinuxKeymap::GetKeyMouseBit(Key));
		}
		else
		{
			char KeyVector[32];
			XQueryKeymap( GDisplay, KeyVector );
			std::vector<int> LinuxKeys = LinuxKeymap::GetLinuxKeyFromMinetestKey(Key);
			bool bKeyPressed = false;
			for (const auto& LKey : LinuxKeys)
			{
				KeyCode KeyCode2 = XKeysymToKeycode( GDisplay, LKey );
				bKeyPressed |= !!( KeyVector[ KeyCode2 >> 3 ] & ( 1 << (KeyCode2 & 7) ) );
			}
			return bKeyPressed;
		}
	}
	else
	{
		std::cout << "ERROR: Display not initalized!!!" << std::endl;
		return false;
	}
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
	bInitalized = true;

    InitKeyPair(XK_BackSpace, 				EKeyCode::KEY_BACK);
	InitKeyPair(XK_Tab, 					EKeyCode::KEY_TAB);
	InitKeyPair(XK_ISO_Left_Tab, 			EKeyCode::KEY_TAB);
	//InitKeyPair(XK_Linefeed, 				EKeyCode::KEY_UNKNOWN); // ???
	InitKeyPair(XK_Clear, 					EKeyCode::KEY_CLEAR);
	InitKeyPair(XK_Return, 					EKeyCode::KEY_RETURN);
	InitKeyPair(XK_Pause, 					EKeyCode::KEY_PAUSE);
	InitKeyPair(XK_Scroll_Lock, 			EKeyCode::KEY_SCROLL);
	//InitKeyPair(XK_Sys_Req, 0); // ???
	InitKeyPair(XK_Escape, 					EKeyCode::KEY_ESCAPE);
	InitKeyPair(XK_Insert, 					EKeyCode::KEY_INSERT);
	InitKeyPair(XK_Delete, 					EKeyCode::KEY_DELETE);
	InitKeyPair(XK_Home, 					EKeyCode::KEY_HOME);
	InitKeyPair(XK_Left, 					EKeyCode::KEY_LEFT);
	InitKeyPair(XK_Up, 						EKeyCode::KEY_UP);
	InitKeyPair(XK_Right, 					EKeyCode::KEY_RIGHT);
	InitKeyPair(XK_Down, 					EKeyCode::KEY_DOWN);
	InitKeyPair(XK_Prior, 					EKeyCode::KEY_PRIOR);
	InitKeyPair(XK_Page_Up, 				EKeyCode::KEY_PRIOR);
	InitKeyPair(XK_Next, 					EKeyCode::KEY_NEXT);
	InitKeyPair(XK_Page_Down, 				EKeyCode::KEY_NEXT);
	InitKeyPair(XK_End, 					EKeyCode::KEY_END);
	InitKeyPair(XK_Begin, 					EKeyCode::KEY_HOME);
	InitKeyPair(XK_Num_Lock, 				EKeyCode::KEY_NUMLOCK);
	InitKeyPair(XK_KP_Space, 				EKeyCode::KEY_SPACE);
	InitKeyPair(XK_KP_Tab, 					EKeyCode::KEY_TAB);
	InitKeyPair(XK_KP_Enter, 				EKeyCode::KEY_RETURN);
	InitKeyPair(XK_KP_F1, 					EKeyCode::KEY_F1);
	InitKeyPair(XK_KP_F2, 					EKeyCode::KEY_F2);
	InitKeyPair(XK_KP_F3, 					EKeyCode::KEY_F3);
	InitKeyPair(XK_KP_F4, 					EKeyCode::KEY_F4);
	InitKeyPair(XK_KP_Home, 				EKeyCode::KEY_HOME);
	InitKeyPair(XK_KP_Left, 				EKeyCode::KEY_LEFT);
	InitKeyPair(XK_KP_Up, 					EKeyCode::KEY_UP);
	InitKeyPair(XK_KP_Right, 				EKeyCode::KEY_RIGHT);
	InitKeyPair(XK_KP_Down, 				EKeyCode::KEY_DOWN);
	InitKeyPair(XK_Print, 					EKeyCode::KEY_PRINT);
	InitKeyPair(XK_KP_Prior, 				EKeyCode::KEY_PRIOR);
	InitKeyPair(XK_KP_Page_Up, 				EKeyCode::KEY_PRIOR);
	InitKeyPair(XK_KP_Next, 				EKeyCode::KEY_NEXT);
	InitKeyPair(XK_KP_Page_Down, 			EKeyCode::KEY_NEXT);
	InitKeyPair(XK_KP_End, 					EKeyCode::KEY_END);
	InitKeyPair(XK_KP_Begin, 				EKeyCode::KEY_HOME);
	InitKeyPair(XK_KP_Insert, 				EKeyCode::KEY_INSERT);
	InitKeyPair(XK_KP_Delete, 				EKeyCode::KEY_DELETE);
	//InitKeyPair(XK_KP_Equal, 0); // ???
	InitKeyPair(XK_KP_Multiply, 			EKeyCode::KEY_MULTIPLY);
	InitKeyPair(XK_KP_Add, 					EKeyCode::KEY_ADD);
	InitKeyPair(XK_KP_Separator, 			EKeyCode::KEY_SEPARATOR);
	InitKeyPair(XK_KP_Subtract, 			EKeyCode::KEY_SUBTRACT);
	InitKeyPair(XK_KP_Decimal, 				EKeyCode::KEY_DECIMAL);
	InitKeyPair(XK_KP_Divide, 				EKeyCode::KEY_DIVIDE);
	InitKeyPair(XK_KP_0, 					EKeyCode::KEY_NUMPAD0);
	InitKeyPair(XK_KP_1, 					EKeyCode::KEY_NUMPAD1);
	InitKeyPair(XK_KP_2, 					EKeyCode::KEY_NUMPAD2);
	InitKeyPair(XK_KP_3, 					EKeyCode::KEY_NUMPAD3);
	InitKeyPair(XK_KP_4, 					EKeyCode::KEY_NUMPAD4);
	InitKeyPair(XK_KP_5, 					EKeyCode::KEY_NUMPAD5);
	InitKeyPair(XK_KP_6, 					EKeyCode::KEY_NUMPAD6);
	InitKeyPair(XK_KP_7, 					EKeyCode::KEY_NUMPAD7);
	InitKeyPair(XK_KP_8, 					EKeyCode::KEY_NUMPAD8);
	InitKeyPair(XK_KP_9, 					EKeyCode::KEY_NUMPAD9);
	InitKeyPair(XK_F1, 						EKeyCode::KEY_F1);
	InitKeyPair(XK_F2, 						EKeyCode::KEY_F2);
	InitKeyPair(XK_F3, 						EKeyCode::KEY_F3);
	InitKeyPair(XK_F4, 						EKeyCode::KEY_F4);
	InitKeyPair(XK_F5, 						EKeyCode::KEY_F5);
	InitKeyPair(XK_F6, 						EKeyCode::KEY_F6);
	InitKeyPair(XK_F7, 						EKeyCode::KEY_F7);
	InitKeyPair(XK_F8, 						EKeyCode::KEY_F8);
	InitKeyPair(XK_F9, 						EKeyCode::KEY_F9);
	InitKeyPair(XK_F10, 					EKeyCode::KEY_F10);
	InitKeyPair(XK_F11, 					EKeyCode::KEY_F11);
	InitKeyPair(XK_F12, 					EKeyCode::KEY_F12);
	InitKeyPair(XK_Shift_L, 				EKeyCode::KEY_LSHIFT);
	InitKeyPair(XK_Shift_R, 				EKeyCode::KEY_RSHIFT);
	InitKeyPair(XK_Control_L, 				EKeyCode::KEY_LCONTROL);
	InitKeyPair(XK_Control_R, 				EKeyCode::KEY_RCONTROL);
	InitKeyPair(XK_Caps_Lock, 				EKeyCode::KEY_CAPITAL);
	InitKeyPair(XK_Shift_Lock, 				EKeyCode::KEY_CAPITAL);
	InitKeyPair(XK_Meta_L, 					EKeyCode::KEY_LWIN);
	InitKeyPair(XK_Meta_R, 					EKeyCode::KEY_RWIN);
	InitKeyPair(XK_Alt_L, 					EKeyCode::KEY_LMENU);
	InitKeyPair(XK_Alt_R, 					EKeyCode::KEY_RMENU);
	InitKeyPair(XK_ISO_Level3_Shift, 		EKeyCode::KEY_RMENU);
	InitKeyPair(XK_Menu, 					EKeyCode::KEY_MENU);
	InitKeyPair(XK_space, 					EKeyCode::KEY_SPACE);
	//InitKeyPair(XK_exclam, 0); //?
	//InitKeyPair(XK_quotedbl, 0); //?
	//InitKeyPair(XK_section, 0); //?
	InitKeyPair(XK_numbersign, 				EKeyCode::KEY_OEM_2);
	//InitKeyPair(XK_dollar, 0); //?
	//InitKeyPair(XK_percent, 0); //?
	//InitKeyPair(XK_ampersand, 0); //?
	InitKeyPair(XK_apostrophe, 				EKeyCode::KEY_OEM_7);
	//InitKeyPair(XK_parenleft, 0); //?
	//InitKeyPair(XK_parenright, 0); //?
	//InitKeyPair(XK_asterisk, 0); //?
	InitKeyPair(XK_plus, 					EKeyCode::KEY_PLUS); //?
	InitKeyPair(XK_comma, 					EKeyCode::KEY_COMMA); //?
	InitKeyPair(XK_minus, 					EKeyCode::KEY_MINUS); //?
	InitKeyPair(XK_period, 					EKeyCode::KEY_PERIOD); //?
	InitKeyPair(XK_slash, 					EKeyCode::KEY_OEM_2); //?
	InitKeyPair(XK_0, 						EKeyCode::KEY_KEY_0);
	InitKeyPair(XK_1, 						EKeyCode::KEY_KEY_1);
	InitKeyPair(XK_2, 						EKeyCode::KEY_KEY_2);
	InitKeyPair(XK_3, 						EKeyCode::KEY_KEY_3);
	InitKeyPair(XK_4, 						EKeyCode::KEY_KEY_4);
	InitKeyPair(XK_5, 						EKeyCode::KEY_KEY_5);
	InitKeyPair(XK_6, 						EKeyCode::KEY_KEY_6);
	InitKeyPair(XK_7, 						EKeyCode::KEY_KEY_7);
	InitKeyPair(XK_8, 						EKeyCode::KEY_KEY_8);
	InitKeyPair(XK_9, 						EKeyCode::KEY_KEY_9);
	//InitKeyPair(XK_colon, 0); //?
	InitKeyPair(XK_semicolon, 				EKeyCode::KEY_OEM_1);
	InitKeyPair(XK_less, 					EKeyCode::KEY_OEM_102);
	InitKeyPair(XK_equal, 					EKeyCode::KEY_PLUS);
	//InitKeyPair(XK_greater, 0); //?
	//InitKeyPair(XK_question, 0); //?
	InitKeyPair(XK_at, 						EKeyCode::KEY_KEY_2); //?
	//InitKeyPair(XK_mu, 0); //?
	//InitKeyPair(XK_EuroSign, 0); //?
	InitKeyPair(XK_A, 						EKeyCode::KEY_KEY_A);
	InitKeyPair(XK_B, 						EKeyCode::KEY_KEY_B);
	InitKeyPair(XK_C, 						EKeyCode::KEY_KEY_C);
	InitKeyPair(XK_D, 						EKeyCode::KEY_KEY_D);
	InitKeyPair(XK_E, 						EKeyCode::KEY_KEY_E);
	InitKeyPair(XK_F, 						EKeyCode::KEY_KEY_F);
	InitKeyPair(XK_G, 						EKeyCode::KEY_KEY_G);
	InitKeyPair(XK_H, 						EKeyCode::KEY_KEY_H);
	InitKeyPair(XK_I, 						EKeyCode::KEY_KEY_I);
	InitKeyPair(XK_J, 						EKeyCode::KEY_KEY_J);
	InitKeyPair(XK_K, 						EKeyCode::KEY_KEY_K);
	InitKeyPair(XK_L, 						EKeyCode::KEY_KEY_L);
	InitKeyPair(XK_M, 						EKeyCode::KEY_KEY_M);
	InitKeyPair(XK_N, 						EKeyCode::KEY_KEY_N);
	InitKeyPair(XK_O, 						EKeyCode::KEY_KEY_O);
	InitKeyPair(XK_P, 						EKeyCode::KEY_KEY_P);
	InitKeyPair(XK_Q, 						EKeyCode::KEY_KEY_Q);
	InitKeyPair(XK_R, 						EKeyCode::KEY_KEY_R);
	InitKeyPair(XK_S, 						EKeyCode::KEY_KEY_S);
	InitKeyPair(XK_T, 						EKeyCode::KEY_KEY_T);
	InitKeyPair(XK_U, 						EKeyCode::KEY_KEY_U);
	InitKeyPair(XK_V, 						EKeyCode::KEY_KEY_V);
	InitKeyPair(XK_W, 						EKeyCode::KEY_KEY_W);
	InitKeyPair(XK_X, 						EKeyCode::KEY_KEY_X);
	InitKeyPair(XK_Y, 						EKeyCode::KEY_KEY_Y);
	InitKeyPair(XK_Z, 						EKeyCode::KEY_KEY_Z);
	InitKeyPair(XK_bracketleft, 			EKeyCode::KEY_OEM_4);
	InitKeyPair(XK_backslash, 				EKeyCode::KEY_OEM_5);
	InitKeyPair(XK_bracketright, 			EKeyCode::KEY_OEM_6);
	InitKeyPair(XK_asciicircum, 			EKeyCode::KEY_OEM_5);
	InitKeyPair(XK_dead_circumflex, 		EKeyCode::KEY_OEM_5);
	//InitKeyPair(XK_degree, 0); //?
	InitKeyPair(XK_underscore, 				EKeyCode::KEY_MINUS); //?
	InitKeyPair(XK_grave, 					EKeyCode::KEY_OEM_3);
	InitKeyPair(XK_dead_grave, 				EKeyCode::KEY_OEM_3);
	InitKeyPair(XK_acute, 					EKeyCode::KEY_OEM_6);
	InitKeyPair(XK_dead_acute, 				EKeyCode::KEY_OEM_6);
	InitKeyPair(XK_a, 						EKeyCode::KEY_KEY_A);
	InitKeyPair(XK_b, 						EKeyCode::KEY_KEY_B);
	InitKeyPair(XK_c, 						EKeyCode::KEY_KEY_C);
	InitKeyPair(XK_d, 						EKeyCode::KEY_KEY_D);
	InitKeyPair(XK_e, 						EKeyCode::KEY_KEY_E);
	InitKeyPair(XK_f, 						EKeyCode::KEY_KEY_F);
	InitKeyPair(XK_g, 						EKeyCode::KEY_KEY_G);
	InitKeyPair(XK_h, 						EKeyCode::KEY_KEY_H);
	InitKeyPair(XK_i, 						EKeyCode::KEY_KEY_I);
	InitKeyPair(XK_j, 						EKeyCode::KEY_KEY_J);
	InitKeyPair(XK_k, 						EKeyCode::KEY_KEY_K);
	InitKeyPair(XK_l, 						EKeyCode::KEY_KEY_L);
	InitKeyPair(XK_m, 						EKeyCode::KEY_KEY_M);
	InitKeyPair(XK_n, 						EKeyCode::KEY_KEY_N);
	InitKeyPair(XK_o, 						EKeyCode::KEY_KEY_O);
	InitKeyPair(XK_p, 						EKeyCode::KEY_KEY_P);
	InitKeyPair(XK_q, 						EKeyCode::KEY_KEY_Q);
	InitKeyPair(XK_r, 						EKeyCode::KEY_KEY_R);
	InitKeyPair(XK_s, 						EKeyCode::KEY_KEY_S);
	InitKeyPair(XK_t, 						EKeyCode::KEY_KEY_T);
	InitKeyPair(XK_u, 						EKeyCode::KEY_KEY_U);
	InitKeyPair(XK_v, 						EKeyCode::KEY_KEY_V);
	InitKeyPair(XK_w, 						EKeyCode::KEY_KEY_W);
	InitKeyPair(XK_x, 						EKeyCode::KEY_KEY_X);
	InitKeyPair(XK_y, 						EKeyCode::KEY_KEY_Y);
	InitKeyPair(XK_z, 						EKeyCode::KEY_KEY_Z);
	InitKeyPair(XK_ssharp, 					EKeyCode::KEY_OEM_4);
	InitKeyPair(XK_adiaeresis, 				EKeyCode::KEY_OEM_7);
	InitKeyPair(XK_odiaeresis, 				EKeyCode::KEY_OEM_3);
	InitKeyPair(XK_udiaeresis, 				EKeyCode::KEY_OEM_1);
	InitKeyPair(XK_Super_L, 				EKeyCode::KEY_LWIN);
	InitKeyPair(XK_Super_R, 				EKeyCode::KEY_RWIN);
}

void LinuxKeymap::InitKeyPair(int LinuxKey, EKeyCode::Type MinetestKey)
{
	if (LinuxKeymap::LinuxToMinetest.find(LinuxKey) != LinuxKeymap::LinuxToMinetest.end())
	{
		LinuxKeymap::LinuxToMinetest[LinuxKey].push_back(MinetestKey);
	}
	else{
    	LinuxKeymap::LinuxToMinetest[LinuxKey] = {MinetestKey};
	}

	if (LinuxKeymap::MinetestToLinux.find(MinetestKey) != LinuxKeymap::MinetestToLinux.end())
	{
		LinuxKeymap::MinetestToLinux[MinetestKey].push_back(LinuxKey);
	}
	else{
    	LinuxKeymap::MinetestToLinux[MinetestKey] = {LinuxKey};
	}
}

std::vector<int> LinuxKeymap::GetLinuxKeyFromMinetestKey(EKeyCode::Type Key)
{
    auto it = LinuxKeymap::MinetestToLinux.find(Key);
    if (it != LinuxKeymap::MinetestToLinux.end())
    {
        return it->second;
    }
    return {};
}

std::vector<EKeyCode::Type> LinuxKeymap::GetMinetestKeyFromLinuxKey(int Key)
{
    auto it = LinuxKeymap::LinuxToMinetest.find(Key);
    if (it != LinuxKeymap::LinuxToMinetest.end())
    {
        return it->second;
    }
    return {};
}

bool LinuxKeymap::IsKeyActuallyMouse(EKeyCode::Type Key)
{
	switch (Key)
	{
		// intentional fallthrough
		case EKeyCode::KEY_LBUTTON:
		case EKeyCode::KEY_RBUTTON:
		case EKeyCode::KEY_MBUTTON:
		case EKeyCode::KEY_XBUTTON1:
		case EKeyCode::KEY_XBUTTON2:
			return true;
		default: return false;
	}
}

unsigned int LinuxKeymap::GetKeyMouseBit(EKeyCode::Type Key)
{
	switch (Key)
	{
		case EKeyCode::KEY_LBUTTON:
			return Button1Mask;
		case EKeyCode::KEY_RBUTTON:
			return Button3Mask;
		case EKeyCode::KEY_MBUTTON:
			return Button2Mask;
		case EKeyCode::KEY_XBUTTON1:
			return Button4Mask;
		case EKeyCode::KEY_XBUTTON2:
			return Button5Mask;
		default: return 0;
	}
}


#endif //QTS_LINUX

