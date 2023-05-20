import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/searchpage/search_bloc.dart';

class SearchResult extends StatefulWidget {
  final int index;
  const SearchResult({Key? key, required this.index}) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // state.searchResults?.removeAt(i);
        BlocProvider.of<SearchBloc>(context)
            .add(DeleteSearchResult(widget.index));
        setState(() {});
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Icon(
                Icons.close_outlined,
                color: Colors.white,
                // size: 30,
              )),
        ),
      ),
    );
  }
}
