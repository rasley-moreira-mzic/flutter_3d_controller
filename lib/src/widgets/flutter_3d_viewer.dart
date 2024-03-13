import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/src/controllers/flutter_3d_controller.dart';
import 'package:flutter_3d_controller/src/data/datasources/i_flutter_3d_datasource.dart';
import 'package:flutter_3d_controller/src/data/repositories/flutter_3d_repository.dart';
import 'package:flutter_3d_controller/src/modules/model_viewer/model_viewer.dart';
import 'package:flutter_3d_controller/src/utils/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Flutter3DViewer extends StatefulWidget {

  final String src;
  final Flutter3DController? controller;
  final Function? onViewCreated;
  final String? fieldOfView;
  final String? cameraOrbit;
  final String? cameraTarget;
  final bool autoPlay;

  const Flutter3DViewer({super.key,required this.src,this.controller, this.onViewCreated, this.fieldOfView, this.cameraOrbit, this.cameraTarget, this.autoPlay=true});

  @override
  State<Flutter3DViewer> createState() => _Flutter3DViewerState();

}

class _Flutter3DViewerState extends State<Flutter3DViewer> {

  Flutter3DController? _controller;
  late String _id;
  final Utils _utils = Utils();

  @override
  void initState() {
    _id = _utils.generateId();
    _controller = widget.controller;
    _controller = widget.controller ?? Flutter3DController();
    if(kIsWeb){
      _controller?.init(Flutter3DRepository(IFlutter3DDatasource(null)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      id: _id,
      src: widget.src,
      relatedJs: _utils.injectedJS(),
      fieldOfView: widget.fieldOfView,
      cameraOrbit: widget.cameraOrbit,
      cameraTarget: widget.cameraOrbit,
      ar: false,
      autoPlay: widget.autoPlay,
      autoRotate: false,
      debugLogging: false,
      interactionPrompt: InteractionPrompt.none,
      onWebViewCreated: kIsWeb ? null : (WebViewController value) async {
        _controller?.init(Flutter3DRepository(IFlutter3DDatasource(value)));
        widget.onViewCreated?.call();
      },
    );
  }
}
