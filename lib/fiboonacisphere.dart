import 'dart:math' as math;
import 'package:flutter/material.dart';

class FibonacciSpherePage extends StatefulWidget {
  const FibonacciSpherePage({super.key});

  @override
  State<FibonacciSpherePage> createState() => _FibonacciSpherePageState();
}

class _FibonacciSpherePageState extends State<FibonacciSpherePage>
    with SingleTickerProviderStateMixin {
  int numPoints = 500;
  double rotationX = 0;
  double rotationY = 0;
  bool isDragging = true;
  Offset? lastPosition;
  
  
  double rotationSpeed = 0.005;
  double wobbleAmount = 0.0;
  double tailLength = 0.5;

  late AnimationController _controller;
  
  
  final List<List<Offset>> _pointTrails = [];

  @override
  void initState() {
    super.initState();

    
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 16))
          ..addListener(() {
            if (!isDragging) {
              setState(() {
                rotationY += rotationSpeed;
              });
            }
          });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
      lastPosition = details.localPosition;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isDragging || lastPosition == null) return;

    final current = details.localPosition;
    final delta = current - lastPosition!;

    setState(() {
      rotationX += delta.dy * 0.01;
      rotationY += delta.dx * 0.01;
      lastPosition = current;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDragging = false;
      lastPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Fibonacci Sphere',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GestureDetector(
                            onPanStart: _onPanStart,
                            onPanUpdate: _onPanUpdate,
                            onPanEnd: _onPanEnd,
                            child: CustomPaint(
                              painter: _FibonacciSpherePainter(
                                numPoints: numPoints,
                                rotationX: rotationX,
                                rotationY: rotationY,
                                wobbleAmount: wobbleAmount,
                                time: _controller.value * 10,
                                tailLength: tailLength,
                                pointTrails: _pointTrails,
                                onTrailsUpdate: (trails) {
                                  _pointTrails.clear();
                                  _pointTrails.addAll(trails);
                                },
                              ),
                              child: SizedBox(
                                width: constraints.maxWidth - 100,
                                height: constraints.maxHeight,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF020617).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 30,
                          spreadRadius: -8,
                          offset: Offset(0, 18),
                          color: Colors.black87,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Number of Points: $numPoints',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: numPoints.toDouble(),
                          min: 50,
                          max: 2000,
                          divisions: 20,
                          onChanged: (v) {
                            setState(() {
                              numPoints = v.round();
                            });
                          },
                          activeColor: const Color(0xFF60A5FA),
                          inactiveColor: const Color(0xFF1E293B),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rotation Speed: ${(rotationSpeed * 100).toStringAsFixed(1)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: rotationSpeed,
                          min: 0.0,
                          max: 0.02,
                          divisions: 40,
                          onChanged: (v) {
                            setState(() {
                              rotationSpeed = v;
                            });
                          },
                          activeColor: const Color(0xFF60A5FA),
                          inactiveColor: const Color(0xFF1E293B),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Wobble Amount: ${(wobbleAmount * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: wobbleAmount,
                          min: 0.0,
                          max: 1.0,
                          divisions: 20,
                          onChanged: (v) {
                            setState(() {
                              wobbleAmount = v;
                            });
                          },
                          activeColor: const Color(0xFF60A5FA),
                          inactiveColor: const Color(0xFF1E293B),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tail Length: ${(tailLength * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: tailLength,
                          min: 0.0,
                          max: 1.0,
                          divisions: 20,
                          onChanged: (v) {
                            setState(() {
                              tailLength = v;
                            });
                          },
                          activeColor: const Color(0xFF60A5FA),
                          inactiveColor: const Color(0xFF1E293B),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FibonacciSpherePainter extends CustomPainter {
  final int numPoints;
  final double rotationX;
  final double rotationY;
  final double wobbleAmount;
  final double time;
  final double tailLength;
  final List<List<Offset>> pointTrails;
  final Function(List<List<Offset>>) onTrailsUpdate;

  _FibonacciSpherePainter({
    required this.numPoints,
    required this.rotationX,
    required this.rotationY,
    required this.wobbleAmount,
    required this.time,
    required this.tailLength,
    required this.pointTrails,
    required this.onTrailsUpdate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    
    final bgPaint = Paint()
      ..color = const Color.fromARGB(0, 15, 23, 42)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final points = _generateFibonacciSphere(numPoints);

    
    final projected = <_ProjectedPoint>[];
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      
      
      final wobblyPoint = _applyWobble(p, i, time, wobbleAmount);
      
      final rotated = _rotatePoint(wobblyPoint, rotationX, rotationY);
      final proj = _projectPoint(rotated, size);

      projected.add(
        _ProjectedPoint(
          x: proj.x,
          y: proj.y,
          z: rotated.z,
          scale: proj.scale,
          index: i,
        ),
      );
    }

    
    final maxTrailLength = (tailLength * 15).round();
    final newTrails = <List<Offset>>[];
    
    for (int i = 0; i < projected.length; i++) {
      final currentPos = Offset(projected[i].x, projected[i].y);
      
      
      List<Offset> trail;
      if (i < pointTrails.length) {
        trail = List.from(pointTrails[i]);
      } else {
        trail = [];
      }
      
      
      trail.insert(0, currentPos);
      
      
      if (trail.length > maxTrailLength) {
        trail = trail.sublist(0, maxTrailLength);
      }
      
      newTrails.add(trail);
    }
    
    
    onTrailsUpdate(newTrails);

    
    projected.sort((a, b) => a.z.compareTo(b.z));

    
    for (final point in projected) {
      final hue = (point.index / numPoints) * 10.0;
      
      
      if (point.index < newTrails.length && tailLength > 0) {
        final trail = newTrails[point.index];
        
        for (int t = 1; t < trail.length; t++) {
          final alpha = (1.0 - (t / trail.length)) * 0.4;
          final trailColor = HSLColor.fromAHSL(
            alpha.clamp(0.0, 1.0),
            hue,
            0.4,
            0.5,
          ).toColor();
          
          final trailPaint = Paint()
            ..color = trailColor
            ..strokeWidth = 2.5 * (2.0 - (t / trail.length))
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;
          
          canvas.drawLine(trail[t - 1], trail[t], trailPaint);
        }
      }
      
      
      final sizeBase = 1.5;
      final radius = sizeBase + point.scale * 1.2;
      final alpha = 0.3 + point.scale * 0.5;

      final color = HSLColor.fromAHSL(
        alpha.clamp(1.0, 1.0),
        hue,
        0.4,
        0.5,
      ).toColor();

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(point.x, point.y), radius, paint);

      
      if (point.z > 0) {
        final glowPaint = Paint()
          ..color = color.withOpacity(alpha * 0.2)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(point.x, point.y), radius * 1.0, glowPaint);
      }
    }
  }

  
  _Point3D _applyWobble(_Point3D p, int index, double time, double amount) {
    if (amount == 0.0) return p;
    
    
    final wobbleX = math.sin(time * 2 + index * 0.1) * amount * 0.15;
    final wobbleY = math.cos(time * 1.5 + index * 0.15) * amount * 0.15;
    final wobbleZ = math.sin(time * 1.8 + index * 0.12) * amount * 0.15;
    
    return _Point3D(
      p.x + wobbleX,
      p.y + wobbleY,
      p.z + wobbleZ,
    );
  }

  
  List<_Point3D> _generateFibonacciSphere(int n) {
    final points = <_Point3D>[];

    if (n <= 1) {
      points.add(const _Point3D(0, 0, 0));
      return points;
    }

    final phi = math.pi * (3 - math.sqrt(5)); 

    for (int i = 0; i < n; i++) {
      final y = 1 - (i / (n - 1)) * 2; 
      final radius = math.sqrt(1 - y * y);
      final theta = phi * i;

      final x = math.cos(theta) * radius;
      final z = math.sin(theta) * radius;

      points.add(_Point3D(x, y, z));
    }
    return points;
  }

  
  _Point3D _rotatePoint(_Point3D p, double rotX, double rotY) {
    
    double x = p.x * math.cos(rotY) - p.z * math.sin(rotY);
    double z = p.x * math.sin(rotY) + p.z * math.cos(rotY);
    double y = p.y;

    
    final y2 = y * math.cos(rotX) - z * math.sin(rotX);
    final z2 = y * math.sin(rotX) + z * math.cos(rotX);

    return _Point3D(x, y2, z2);
  }

  _ProjectedPoint _projectPoint(_Point3D p, Size size) {
    const scale = 180.0;
    const distance = 4.0;

    final perspective = distance / (distance + p.z);
    final x = p.x * scale * perspective + size.width / 2;
    final y = p.y * scale * perspective + size.height / 2;

    return _ProjectedPoint(
      x: x,
      y: y,
      z: p.z,
      scale: perspective,
      index: 0,
    );
  }

  @override
  bool shouldRepaint(covariant _FibonacciSpherePainter oldDelegate) {
    return oldDelegate.numPoints != numPoints ||
        oldDelegate.rotationX != rotationX ||
        oldDelegate.rotationY != rotationY ||
        oldDelegate.wobbleAmount != wobbleAmount ||
        oldDelegate.time != time ||
        oldDelegate.tailLength != tailLength;
  }
}

class _Point3D {
  final double x;
  final double y;
  final double z;

  const _Point3D(this.x, this.y, this.z);
}

class _ProjectedPoint {
  final double x;
  final double y;
  final double z;
  final double scale;
  final int index;

  _ProjectedPoint({
    required this.x,
    required this.y,
    required this.z,
    required this.scale,
    required this.index,
  });

  _ProjectedPoint copyWith({
    double? x,
    double? y,
    double? z,
    double? scale,
    int? index,
  }) {
    return _ProjectedPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      z: z ?? this.z,
      scale: scale ?? this.scale,
      index: index ?? this.index,
    );
  }
}