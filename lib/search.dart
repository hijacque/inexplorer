import 'package:flutter/material.dart';

import 'dart:async';

import 'package:inexplorer_app/style.dart';

class LocationSearchTextField extends StatefulWidget {
  final FocusNode fieldFocusNode;
  final TextEditingController fieldTextController;
  final String? hintText;
  final int locationsLimit;
  final bool delayOptionLoad;
  final Duration loadDelay;
  final Future<List<Map<String, dynamic>>> Function(String value) loadOptions;
  final void Function(Map<String, dynamic>) onSelected;

  LocationSearchTextField({
    Key? key,
    required this.fieldFocusNode,
    required this.fieldTextController,
    required this.loadOptions,
    required this.onSelected,
    this.locationsLimit = -1,
    this.delayOptionLoad = false,
    this.loadDelay = const Duration(seconds: 1),
    this.hintText,
  }) : super(key: key);

  @override
  State<LocationSearchTextField> createState() =>
      _LocationSearchTextFieldState();
}

class _LocationSearchTextFieldState extends State<LocationSearchTextField> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _options = [];
  Timer? _timer;
  Map<String, dynamic>? _selectedLocation;

  void _startTimer() async {
    _timer?.cancel();

    String newText = widget.fieldTextController.text;
    if (newText == '') {
      setState(() {
        _isLoading = false;
        _options = [];
      });
      return;
    }

    if (!widget.delayOptionLoad) {
      _options = await widget.loadOptions(newText);
      return;
    }

    setState(() {
      _isLoading = true;
      _options = [];
    });

    _timer = Timer(widget.loadDelay, () async {
      _options = await widget.loadOptions(newText);
      setState(() {
        widget.fieldTextController.text = newText;
        widget.fieldFocusNode.requestFocus();
        _isLoading = false;
      });
    });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<Map<String, dynamic>>(
      focusNode: widget.fieldFocusNode,
      textEditingController: widget.fieldTextController,
      displayStringForOption: (option) => option['name'].toString(),
      onSelected: widget.onSelected,
      optionsBuilder: (TextEditingValue editedValue) => _options,
      optionsViewBuilder: (context, onSelected, options) {
        if (_options.isEmpty) return Container();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.grey, blurRadius: 8.0, spreadRadius: 1),
                ],
                border: Border.all(color: LIGHT, width: 2),
              ),
              margin: const EdgeInsets.only(
                top: 8,
                right: 48,
              ),
              clipBehavior: Clip.hardEdge,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220.0),
                child: ListView.separated(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    Map<String, dynamic> location = options.elementAt(i);
                    return Material(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          location['name'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          location['address'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        selected: location == _selectedLocation,
                        selectedTileColor: LIGHT,
                        onTap: () {
                          setState(() {
                            _selectedLocation = location;
                            widget.fieldTextController.text = location['name'];
                            widget.fieldFocusNode.unfocus();
                            onSelected(location);
                          });
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => const Divider(
                    height: 1.5,
                    color: LIGHT,
                  ),
                  itemCount: options.length,
                ),
              ),
            ),
          ],
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return Container(
          // margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(color: Colors.grey, blurRadius: 8.0, spreadRadius: 1),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: PURPLE,
            decoration: LightTextFieldStyle.copyWith(
              prefixIconConstraints: const BoxConstraints.expand(width: 56, height: 56),
              prefixIcon: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: Center(
                        child: CircularProgressIndicator(color: LIGHT_PURPLE),
                      ),
                    )
                  : const Icon(Icons.search, size: 26.0, color: Colors.grey),
              suffixIcon: controller.text.isNotEmpty || focusNode.hasFocus
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          focusNode.unfocus();
                          controller.text = '';
                          _options.clear();
                        });
                      },
                      icon: const Icon(Icons.close, size: 24, color: PURPLE),
                    )
                  : null,
              hintText: widget.hintText ?? '',
            ),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            onChanged: (value) {
              _startTimer();
            },
          ),
        );
      },
    );
  }
}
