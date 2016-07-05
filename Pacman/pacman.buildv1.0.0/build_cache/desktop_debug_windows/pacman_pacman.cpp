
#include "pacman_pacman.h"

// ***** External *****

#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_app_2app.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_app_2event.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_graphics_2canvas.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/mojo/mojo.buildv1.0.0/desktop_debug_windows/mojo_input_2mouse.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/monkey/monkey.buildv1.0.0/desktop_debug_windows/monkey_types.h"
#include "pacman_src_2sprites.h"
#include "../../../../../../Monkey/monkey2-v1.0.0/modules/std/std.buildv1.0.0/desktop_debug_windows/std_graphics_2color.h"

extern void g_pacman_InitialiseGrid();
extern void g_pacman_InitialiseFont();
extern void g_std_random_SeedRnd(bbULong l_seed);
extern void g_pacman_RenderGrid(t_mojo_graphics_Canvas* l_canvas);
extern void g_pacman_DrawFont(t_mojo_graphics_Canvas* l_canvas,bbString l_text,bbInt l_x,bbInt l_y,t_std_graphics_Color l_color);

// ***** Internal *****

bbGCRootVar<t_pacman_PacmanWindow> g_pacman_window;
t_std_geom_Vec2_1i g_pacman_DisplayOffset;

void bbMain(){
  static bool done;
  if(done) return;
  done=true;
  void mx2_mojo_main();mx2_mojo_main();
  void mx2_std_main();mx2_std_main();
  bbDBFrame db_f{"Main:Void()","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  bbDBStmt(81921);
  bbGCNew<t_mojo_app_AppInstance>();
  bbDBStmt(86017);
  g_pacman_window=bbGCNew<t_pacman_PacmanWindow>(BB_T("Pacman"),640,480,8);
  bbDBStmt(90113);
  g_mojo_app_App->m_Run();
}

void t_pacman_PacmanWindow::dbEmit(){
  t_mojo_app_Window::dbEmit();
  bbDBEmit("IsPaused",&m_IsPaused);
  bbDBEmit("IsSuspended",&m_IsSuspended);
  bbDBEmit("ShowFPS",&m_ShowFPS);
  bbDBEmit("IsDebug",&m_IsDebug);
  bbDBEmit("MoveGhosts",&m_MoveGhosts);
}

t_pacman_PacmanWindow::t_pacman_PacmanWindow(bbString l_title,bbInt l_width,bbInt l_height,bbInt l_flags):t_mojo_app_Window(l_title,l_width,l_height,l_flags){
  bbDBFrame db_f{"new:Void(title:String,width:Int,height:Int,flags:mojo.app.WindowFlags)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  bbDBLocal("title",&l_title);
  bbDBLocal("width",&l_width);
  bbDBLocal("height",&l_height);
  bbDBLocal("flags",&l_flags);
  bbDBStmt(151554);
  this->m_ClearColor(g_std_graphics_Color_Black);
  bbDBStmt(155650);
  g_mojo_input_Mouse->m_PointerVisible(false);
  bbDBStmt(172034);
  g_pacman_InitialiseSprites();
  bbDBStmt(176130);
  g_pacman_InitialiseGrid();
  bbDBStmt(180226);
  g_pacman_InitialiseFont();
  bbDBStmt(192514);
  g_std_random_SeedRnd(12345678);
}

void t_pacman_PacmanWindow::m_OnWindowEvent(t_mojo_app_WindowEvent* l_event){
  bbDBFrame db_f{"OnWindowEvent:Void(event:mojo.app.WindowEvent)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  t_pacman_PacmanWindow*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("event",&l_event);
  bbInt l_0=l_event->m_Type();
  bbDBLocal("0",&l_0);
  bbDBStmt(438274);
  if(l_0==11){
    bbDBBlock db_blk;
  }else if(l_0==12){
    bbDBBlock db_blk;
    bbDBStmt(450564);
    g_mojo_app_App->m_RequestRender();
  }else if(l_0==13){
    bbDBBlock db_blk;
    bbDBStmt(458756);
    this->m_IsSuspended=false;
  }else if(l_0==14){
    bbDBBlock db_blk;
    bbDBStmt(466948);
    this->m_IsSuspended=true;
  }else{
    bbDBBlock db_blk;
    bbDBStmt(475140);
    t_mojo_app_Window::m_OnWindowEvent(l_event);
  }
}

void t_pacman_PacmanWindow::m_OnRender(t_mojo_graphics_Canvas* l_canvas){
  bbDBFrame db_f{"OnRender:Void(canvas:mojo.graphics.Canvas)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  t_pacman_PacmanWindow*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("canvas",&l_canvas);
  bbDBStmt(217090);
  g_pacman_UpdateSprites();
  bbDBStmt(245762);
  g_mojo_app_App->m_RequestRender();
  bbDBStmt(249858);
  g_pacman_RenderGrid(l_canvas);
  bbDBStmt(253954);
  g_pacman_RenderSprites(l_canvas);
  bbDBStmt(266242);
  l_canvas->m_Color(g_std_graphics_Color_White);
  bbDBStmt(270338);
  g_pacman_DrawFont(l_canvas,BB_T("1UP"),24,bbInt(0),g_std_graphics_Color_White);
  bbDBStmt(274440);
  bbString l_p1Score=(BB_T("      ")+bbString(g_pacman_Yellow->m_Score));
  bbDBLocal("p1Score",&l_p1Score);
  bbDBStmt(278530);
  g_pacman_DrawFont(l_canvas,l_p1Score.right(6),8,8,g_std_graphics_Color_White);
  bbDBStmt(282626);
  g_pacman_DrawFont(l_canvas,BB_T("HIGH SCORE"),72,bbInt(0),g_std_graphics_Color_White);
  bbDBStmt(294914);
  l_canvas->m_Color(g_std_graphics_Color_White);
  bbDBStmt(299010);
  if(this->m_ShowFPS){
    bbDBBlock db_blk;
    bbDBStmt(299023);
    g_pacman_DrawFont(l_canvas,(BB_T("FPS-")+bbString(g_mojo_app_App->m_FPS())),bbInt(0),240,g_std_graphics_Color_White);
  }
}

void t_pacman_PacmanWindow::m_OnKeyEvent(t_mojo_app_KeyEvent* l_event){
  bbDBFrame db_f{"OnKeyEvent:Void(event:mojo.app.KeyEvent)","D:/Dev/Monkey/Pacman/pacman.monkey2"};
  t_pacman_PacmanWindow*self=this;
  bbDBLocal("Self",&self);
  bbDBLocal("event",&l_event);
  bbInt l_0=l_event->m_Type();
  bbDBLocal("0",&l_0);
  bbDBStmt(331778);
  if(l_0==0){
    bbDBBlock db_blk;
    bbInt l_1=l_event->m_Key();
    bbDBLocal("1",&l_1);
    bbDBStmt(339972);
    if(l_1==197){
      bbDBBlock db_blk;
      bbDBStmt(348166);
      this->m_Fullscreen(!this->m_Fullscreen());
    }else if(l_1==27){
      bbDBBlock db_blk;
      bbDBStmt(356358);
      g_mojo_app_App->m_Terminate();
    }else if(l_1==102){
      bbDBBlock db_blk;
      bbDBStmt(364550);
      this->m_ShowFPS=!this->m_ShowFPS;
    }else if(l_1==100){
      bbDBBlock db_blk;
      bbDBStmt(372742);
      this->m_IsDebug=!this->m_IsDebug;
    }else if(l_1==186){
      bbDBBlock db_blk;
      bbDBStmt(380934);
      g_pacman_SetGhostMode(bbInt(4));
    }else if(l_1==187){
      bbDBBlock db_blk;
      bbDBStmt(389126);
      g_pacman_SetGhostMode(bbInt(5));
    }else if(l_1==188){
      bbDBBlock db_blk;
      bbDBStmt(397318);
      g_pacman_SetGhostMode(bbInt(6));
    }else if(l_1==109){
      bbDBBlock db_blk;
      bbDBStmt(405510);
      this->m_MoveGhosts=!this->m_MoveGhosts;
    }else if(l_1==114){
      bbDBBlock db_blk;
      bbDBStmt(413702);
      g_pacman_SetGhostReverseDirection();
    }
  }
}
bbString bbDBType(t_pacman_PacmanWindow**){
  return "pacman.PacmanWindow";
}
bbString bbDBValue(t_pacman_PacmanWindow**p){
  return bbDBObjectValue(*p);
}

void mx2_pacman_pacman_init(){
  static bool done;
  if(done) return;
  done=true;
  g_pacman_DisplayOffset=t_std_geom_Vec2_1i(32,bbInt(0));
}

bbInit mx2_pacman_pacman_init_v("pacman_pacman",&mx2_pacman_pacman_init);
