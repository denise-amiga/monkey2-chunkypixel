
#ifndef MX2_PACMAN_PACMAN_H
#define MX2_PACMAN_PACMAN_H

#include <bbmonkey.h>

// ***** External *****

#include "../../../../../../Monkey/monkey2/modules/mojo/mojo.buildv010/desktop_debug_windows/mojo_app_2window.h"
#include "../../../../../../Monkey/monkey2/modules/std/std.buildv010/desktop_debug_windows/std_geom_2vec2.h"

struct t_mojo_app_WindowEvent;
bbString bbDBType(t_mojo_app_WindowEvent**);
bbString bbDBValue(t_mojo_app_WindowEvent**);
struct t_mojo_graphics_Canvas;
bbString bbDBType(t_mojo_graphics_Canvas**);
bbString bbDBValue(t_mojo_graphics_Canvas**);
struct t_mojo_app_KeyEvent;
bbString bbDBType(t_mojo_app_KeyEvent**);
bbString bbDBValue(t_mojo_app_KeyEvent**);

// ***** Internal *****

struct t_pacman_PacmanWindow;

extern bbGCRootVar<t_pacman_PacmanWindow> g_pacman_window;
extern t_std_geom_Vec2_1f g_pacman_DisplayOffset;

extern void bbMain();

struct t_pacman_PacmanWindow : public t_mojo_app_Window{

  const char *typeName()const{return "t_pacman_PacmanWindow";}

  bbBool m_IsPaused{};
  bbBool m_IsSuspended{};
  bbBool m_ShowFPS=false;
  void dbEmit();

  t_pacman_PacmanWindow(bbString l_title,bbInt l_width,bbInt l_height,bbInt l_flags);

  void m_OnWindowEvent(t_mojo_app_WindowEvent* l_event);
  void m_OnRender(t_mojo_graphics_Canvas* l_canvas);
  void m_OnKeyEvent(t_mojo_app_KeyEvent* l_event);

  t_pacman_PacmanWindow(){
  }
};
bbString bbDBType(t_pacman_PacmanWindow**);
bbString bbDBValue(t_pacman_PacmanWindow**);

#endif
