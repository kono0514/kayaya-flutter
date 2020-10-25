import 'package:flutter/material.dart';

class ListBottomLoader extends StatelessWidget {
  /// Whether to render the error or not
  final bool error;
  final VoidCallback onRetry;

  const ListBottomLoader({
    Key key,
    @required this.error,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          bottom: 40.0,
        ),
        child: error == true ? _buildError() : _buildLoader(),
      ),
    );
  }

  Widget _buildLoader() {
    return CircularProgressIndicator();
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
