import 'package:flutter/material.dart';
import 'dart:async';


class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  bool _isBreakMode = false; // Track if we're in break mode (Pomodoro)

  // Controllers for the pickers (kept here to remember values or reused)
  // We recreate them for the sheet to ensure safe attachment
  FixedExtentScrollController? _hoursController;
  FixedExtentScrollController? _minutesController;
  FixedExtentScrollController? _secondsController;

  void _startTimer() {
    if (_totalSeconds == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set a time first!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
          _totalSeconds = 0;
          _remainingSeconds = 0;
        });
        _showCompletionDialog();
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _totalSeconds = 0;
      _remainingSeconds = 0;
      _isBreakMode = false; // Reset break mode
    });
  }

  void _showCompletionDialog() async {
    // Play beep sound if needed
  
    final isWorkSession = !_isBreakMode;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isWorkSession ? 'Work Session Complete!' : 'Break Time Over!'),
        content: Text(isWorkSession 
          ? 'Great job! Time for a 5-minute break.' 
          : 'Break finished! Ready to focus again?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              if (isWorkSession) {
                // Start 5-minute break automatically
                setState(() {
                  _isBreakMode = true;
                  _totalSeconds = 5 * 60; // 5 minutes
                });
                _startTimer();
              } else {
                // Break is over, reset to normal
                setState(() {
                  _isBreakMode = false;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Show the bottom sheet to pick time
  void _openTimePickerSheet() {
    // Initialize controllers with default or previous values if needed
    // Starting at 0 is simpler for now
    _hoursController = FixedExtentScrollController(initialItem: 0);
    _minutesController = FixedExtentScrollController(initialItem: 25); // Default 25 min (Pomodoro)
    _secondsController = FixedExtentScrollController(initialItem: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Set Timer',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              
              // iOS-style picker
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hours
                    Expanded(
                      child: _buildScrollPicker(
                        controller: _hoursController!,
                        itemCount: 24,
                        label: 'hours',
                      ),
                    ),
                    const Text(
                      ':',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    // Minutes
                    Expanded(
                      child: _buildScrollPicker(
                        controller: _minutesController!,
                        itemCount: 60,
                        label: 'min',
                      ),
                    ),
                    const Text(
                      ':',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    // Seconds
                    Expanded(
                      child: _buildScrollPicker(
                        controller: _secondsController!,
                        itemCount: 60,
                        label: 'sec',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Start button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final h = _hoursController!.selectedItem;
                    final m = _minutesController!.selectedItem;
                    final s = _secondsController!.selectedItem;
                    
                    setState(() {
                      _totalSeconds = (h * 3600) + (m * 60) + s;
                    });

                    if (_totalSeconds > 0) {
                      _startTimer();
                      Navigator.pop(context); // Close sheet
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    'Start Timer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    ).then((_) {
      // Cleanup controllers when sheet closes
      _hoursController?.dispose();
      _minutesController?.dispose();
      _secondsController?.dispose();
    });
  }

  void _openControlSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Timer Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: Colors.blue,
                ),
              ),
              
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {
                          _stopTimer();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.stop),
                        iconSize: 32,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red[100],
                          foregroundColor: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Reset', style: TextStyle(fontSize: 12)),
                    ],
                  ),

                  Column(
                    children: [
                      IconButton.filled(
                        onPressed: () {
                          if (_isRunning) {
                            _pauseTimer();
                          } else {
                            _startTimer();
                          }
                          Navigator.pop(context);
                        },
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        iconSize: 48,
                        style: IconButton.styleFrom(
                          backgroundColor: _isRunning ? Colors.orange : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_isRunning ? 'Pause' : 'Resume', 
                        style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always return the circle widget
    return _buildCircleTimer();
  }

  Widget _buildCircleTimer() {
    return GestureDetector(
      onTap: () {
        if (_isRunning || _remainingSeconds > 0) {
          _openControlSheet();
        } else {
          _openTimePickerSheet();
        }
      },
      child: Container(
        width: 60,  // Slightly smaller to fit header better
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRunning || _remainingSeconds > 0) ...[
              Text(
                _formatTime(_remainingSeconds),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: Colors.blue,
                ),
              ),
              if (_isRunning)
                 const Icon(Icons.pause, size: 16, color: Colors.orange)
              else 
                 const Icon(Icons.play_arrow, size: 16, color: Colors.green)
            ] else ...[
              const Icon(
                Icons.timer,
                size: 28,
                color: Colors.blue,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScrollPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String label,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: 40,
          perspective: 0.005,
          diameterRatio: 1.2,
          physics: const FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: itemCount,
            builder: (context, index) {
              return Center(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          right: 4,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}