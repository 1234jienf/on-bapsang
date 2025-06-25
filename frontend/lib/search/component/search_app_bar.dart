import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/search_keyword_remian_provider.dart';
import '../provider/search_switch_component_provider.dart';
import '../view/search_root_screen.dart';

class SearchAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchAppBar({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  ConsumerState<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}

class _SearchAppBarState extends ConsumerState<SearchAppBar> {
  final focusNode = FocusNode();
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = ref.watch(searchKeywordRemainProvider);

    final isFocused = focusNode.hasFocus;
    final hint = isFocused
        ? '아무거나 검색해 보세요!'
        : (keyword.isEmpty ? '아무거나 검색해 보세요!' : keyword);

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: true,
      leadingWidth: 55,
      titleSpacing: 0,
      title: Container(
        margin: const EdgeInsets.only(right: 12.0),
        width: 325,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        child: Focus(
          onFocusChange: (_) => setState(() {}),
          child: TextField(
            focusNode: focusNode,
            controller: searchController,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 15.0),
              filled: true,
              isCollapsed: true,
              fillColor: Colors.grey[100],
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onSubmitted: (value) {
              ref.read(searchSwitchComponentProvider.notifier).clear();
              if (value.trim().isEmpty) return;
              ref.read(searchKeywordRemainProvider.notifier).setKeyword(value);
              context.pushNamed(SearchRootScreen.routeName, extra: value);
              searchController.clear();
            },
          ),
        ),
      ),
    );
  }
}