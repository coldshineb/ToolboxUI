import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TickerTimer {
  final TickerProvider _vsync;
  late Ticker _ticker;
  final Duration _duration;
  final void Function(TickerTimer?) _callback;
  final bool _isPeriodic;
  
  bool _isActive = true;
  Duration _elapsed = Duration.zero;
  Duration _lastTick = Duration.zero;

  TickerTimer(this._vsync, this._duration, void Function() callback)
      : _isPeriodic = false,
        _callback = ((timer) => callback()) {
    _init();
  }

  TickerTimer.periodic(this._vsync, this._duration, void Function(TickerTimer) callback)
      : _isPeriodic = true,
        _callback = ((timer) => callback(timer!)) {
    _init();
  }

  void _init() {
    _ticker = _vsync.createTicker(_onTick);
    _ticker.start();
  }

  void _onTick(Duration timeStamp) {
    if (!_isActive) return;
    
    if (_lastTick == Duration.zero) {
      _lastTick = timeStamp;
      return;
    }

    Duration dt = timeStamp - _lastTick;
    _lastTick = timeStamp;

    // 当 Ticker 被 muted（例如页面切到后台）时，恢复后的下一帧 timeStamp 会包含这段挂机时间，导致 dt 巨大。
    // 我们如果检测到这种巨大跳跃，直接将其限制为一个正常帧的时间，从而实现真正意义上的“时间冻结”。
    if (dt.inMilliseconds > 200) {
      dt = const Duration(milliseconds: 16);
    }

    _elapsed += dt;

    if (_elapsed >= _duration) {
      if (_isPeriodic) {
        // 重置时间，但保留超出部分的余量以防误差积累
        _elapsed = _elapsed - _duration;
        _callback(this);
      } else {
        _isActive = false;
        _ticker.stop();
        _ticker.dispose();
        _callback(null);
      }
    }
  }

  void cancel() {
    if (_isActive) {
      _isActive = false;
      _ticker.stop();
      _ticker.dispose();
    }
  }
}

