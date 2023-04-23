#include "flutter_window.h"

#include <optional>
#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>
#include <string>


#include "flutter/generated_plugin_registrant.h"
using flutter::EncodableMap;
using flutter::EncodableValue;

std::string GetUrlArgument(const flutter::MethodCall<>& method_call) {
  std::string url;
  const auto* arguments = std::get_if<EncodableMap>(method_call.arguments());
  if (arguments) {
    auto url_it = arguments->find(EncodableValue("message"));
    if (url_it != arguments->end()) {
      url = std::get<std::string>(url_it->second);
    }
  }
  return url;
}

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

void showMesssage(std::string& alertMessage){
   std::string narrowString = alertMessage;
    std::wstring wideString; 
    int size = MultiByteToWideChar(CP_UTF8, 0, narrowString.c_str(), -1, nullptr, 0);
    wideString.resize(size);
    MultiByteToWideChar(CP_UTF8, 0, narrowString.c_str(), -1, &wideString[0], size);

    LPCWSTR message = wideString.c_str();
    LPCWSTR title = L"Alert";
    UINT type = MB_OK;

    MessageBox(NULL, message, title, type); 
}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  flutter::MethodChannel<> channel(
      flutter_controller_->engine()->messenger(), "dev.fluttercrew",
      &flutter::StandardMethodCodec::GetInstance());
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
          std::string alertMessage = GetUrlArgument(call);
        if (call.method_name() == "displayAlert") {
          showMesssage(alertMessage);
          result->Success(alertMessage);
        } else {
          result->NotImplemented();
        }
      });
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  return true;
}


void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
