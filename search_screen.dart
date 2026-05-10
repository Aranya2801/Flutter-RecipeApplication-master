import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/search/search_bloc.dart';
import '../../widgets/recipe/recipe_card.dart';
import '../../widgets/common/filter_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<SearchBloc>().add(ClearSearchEvent());
    } else {
      context.read<SearchBloc>().add(SearchQueryEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: 'Search recipes, ingredients...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _controller.clear();
                                  context.read<SearchBloc>().add(ClearSearchEvent());
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => FilterBottomSheet(
                        onApply: (filters) {
                          context.read<SearchBloc>().add(ApplyFiltersEvent(
                            query: _controller.text,
                            difficulty: filters['difficulty'],
                            category: filters['category'],
                            filterCount: filters.values.where((v) => v != null).length,
                          ));
                        },
                      ),
                    ),
                    child: Container(
                      width: 54, height: 54,
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.brandPrimary.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.tune_rounded, color: AppTheme.brandPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) return _buildSuggestionsView(context);
                  if (state is SearchLoading) return const Center(child: CircularProgressIndicator());
                  if (state is SearchSuccess) return _buildResults(context, state);
                  if (state is SearchError) return Center(child: Text(state.message));
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsView(BuildContext context) {
    final suggestions = ['Pasta', 'Ramen', 'Curry', 'Salad', 'Soufflé', 'Croissant', 'Bibimbap', 'Tacos'];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Popular Searches', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: suggestions.asMap().entries.map((e) => GestureDetector(
              onTap: () {
                _controller.text = e.value;
                _onSearch(e.value);
              },
              child: Chip(
                label: Text(e.value),
                avatar: const Icon(Icons.trending_up_rounded, size: 16, color: AppTheme.brandPrimary),
              ).animate(delay: (e.key * 50).ms).fadeIn().scale(),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, SearchSuccess state) {
    if (state.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No recipes found for "${state.query}"',
              style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Try different keywords or remove filters'),
          ],
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text('${state.totalCount} results', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: state.results.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: RecipeCard(
                recipe: state.results[i],
                onTap: () => context.push('/recipe/${state.results[i].id}'),
              ).animate(delay: (i * 60).ms).fadeIn(),
            ),
          ),
        ),
      ],
    );
  }
}
