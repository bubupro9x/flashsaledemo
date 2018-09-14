
///A base class for other blocs. To follow convention, every screen first
///should have a bloc, then if a component is complicated enough, it should have
///it's own bloc
abstract class BaseBloc {

  ///Called if the BlocProvider gets disposed
  void dispose();

}