# config.nims - Configurazione completa senza pkg-config
when defined(windows):
  # Path per supportare sia #include <QtCore/private/...> che #include <private/...>
  switch("cincludes", "C:/msys64/mingw64/include/qt6/QtCore/6.9.1")
  switch("cincludes", "C:/msys64/mingw64/include/qt6/QtGui/6.9.1") 
  switch("cincludes", "C:/msys64/mingw64/include/qt6/QtWidgets/6.9.1")
  switch("cincludes", "C:/msys64/mingw64/include/qt6/QtCore/6.9.1/QtCore")
  switch("cincludes", "C:/msys64/mingw64/include/qt6/QtGui/6.9.1/QtGui")
  switch("cincludes", "C:/msys64/mingw64/include/qt6/QtWidgets/6.9.1/QtWidgets")
  
  switch("app", "gui") #se vogliomo che NON appaia la console!!
 
# configurazione per windows per versioni diverse per ora da qt 6.4.x!
 
