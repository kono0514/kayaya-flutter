import 'package:flutter/material.dart';

class ListLoader extends StatelessWidget {
  /// Whether to render the error or not
  final bool error;
  final VoidCallback onRetry;
  final EdgeInsetsGeometry padding;
  final double spinnerSize;

  const ListLoader({
    Key key,
    @required this.error,
    this.onRetry,
    this.padding = const EdgeInsets.only(
      top: 20.0,
      bottom: 40.0,
    ),
    this.spinnerSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: this.padding,
        child: error == true ? _buildError() : _buildLoader(),
      ),
    );
  }

  Widget _buildLoader() {
    if (spinnerSize == null) {
      return CircularProgressIndicator();
    }

    return SizedBox(
      width: spinnerSize,
      height: spinnerSize,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Column(
      children: <Widget>[
        Text(
          'Error fetching data',
          style: TextStyle(color: Colors.red),
        ),
        if (onRetry != null)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
              onPressed: onRetry,
              child: Text('Retry'),
            ),
          ),
      ],
    );
  }
}
