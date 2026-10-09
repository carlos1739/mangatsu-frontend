// ignore_for_file: library_private_types_in_public_api
part of 'home.dart';

mixin HomeGenre on _HomeStateBase {
  Widget _buildGenrePanel() {
    if (genre.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _textColor.withValues(alpha: .08)),
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...genre.map(
              (item) => ActionChip(
                label: Text(item),
                onPressed: () => _openGenre(item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
