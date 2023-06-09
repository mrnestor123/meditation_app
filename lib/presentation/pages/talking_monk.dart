
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class TalkingMonk extends StatefulWidget {
  const TalkingMonk({Key key}) : super(key: key);

  @override
  State<TalkingMonk> createState() => _TalkingMonkState();
}

class _TalkingMonkState extends State<TalkingMonk> with TickerProviderStateMixin{


  AnimationController _controller;
  Animation<Offset> _offset;

  AnimationController _scaleController;
  Animation<Offset> _scaleOffset;

  // HEIGHT TIENE QUE  SER DINÁMICA !!!
  Widget _animatedTextWidget2 = Container(height: 50);

  //Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    );

    _offset = Tween<Offset>(begin: const Offset(0.0, 2.0), end: Offset.zero)
        .animate(new CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut
      ));


    _scaleController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300),
    );

    _scaleOffset = Tween<Offset>(begin: const Offset(0.0, 2.0), end: Offset.zero)
      .animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut
    ));

    // HAY  QUE AÑADIR ANIMACIÓN AL BOCADILLO
    Future.delayed(
      Duration(seconds: 1),
      () => _controller.forward()
    );

    Future.delayed(
      Duration(seconds: 2),
      () => _scaleController.forward()
    );

    Future.delayed(
      Duration(seconds: 2,milliseconds: 300),
      (){
        _animatedTextWidget2 = AnimatedTextKit(animatedTexts: [
          TyperAnimatedText(
            'Welcome to the Inside APP! I am your guide, the monk. I will help you to meditate and to reach the state of enlightenment.',
            textStyle: Configuration.text('small',Colors.black,font: 'Helvetica'),
            speed: const Duration(milliseconds: 50),
          ),
        ],
        isRepeatingAnimation: false,
        repeatForever: false,
        displayFullTextOnTap: true,
        stopPauseOnTap: true
        );
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children:[
              SlideTransition(
                position: _offset,
                child: Image.asset('assets/monk.png',
                  width:Configuration.width*0.2
                ),
              ),

              Expanded(
                child: ScaleTransition(
                  scale: _scaleController,
                  child: CustomPaint(
                    painter: CustomStyleArrow(),
                    child: Container(
                      padding: EdgeInsets.all(Configuration.smpadding),
                      child: _animatedTextWidget2
                    ),
                  ),
                ),
              ),
              SizedBox(width: Configuration.verticalspacing)
            ]
          ),
        
          SizedBox(height: Configuration.verticalspacing*3)
        ],
      ),
    );
  }
}



class CustomStyleArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0
      ..style = PaintingStyle.fill;

    final double triangleH = 25;
    final double triangleW = 25.0;
    final double width = size.width;
    final double height = size.height;

    final Path trianglePath = Path()
      ..moveTo(0, height/2 )
      ..lineTo(0 - triangleW, height / 2)
      ..lineTo(0, height / 2 - triangleH/2)
      ..lineTo(0, (height / 2) + (triangleH/2));
      
    canvas.drawPath(trianglePath, paint);
    final BorderRadius borderRadius = BorderRadius.circular(15);
    final Rect rect = Rect.fromLTRB(0, 0, width, height);
    final RRect outer = borderRadius.toRRect(rect);
    canvas.drawRRect(outer, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}




  /*
class SlideUpController {
  SlideUpController._private();

  static final SlideUpController instance = SlideUpController._private();

  factory SlideUpController() => instance;

  BuildContext _providerContext;

  set providerContext(BuildContext context) {
    if (_providerContext != context) {
      _providerContext = context;
    }
  }


  void toggle() {
    if (_providerContext != null) {
      final provider = _providerContext.read<SlideUpProvider>();
      provider.updateState(!provider.isShow);
    } else {
      print('Need init provider context');
    }
  }
}*/


