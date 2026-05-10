import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8);
    final highlight = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(width: 160, height: 16, radius: 8),
                  const SizedBox(height: 12),
                  _ShimmerBox(width: double.infinity, height: 36, radius: 10),
                  const SizedBox(height: 8),
                  _ShimmerBox(width: 200, height: 28, radius: 10),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ShimmerBox(width: 120, height: 18, radius: 8),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 108,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 6,
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _ShimmerBox(width: 90, height: 108, radius: 18),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ShimmerBox(width: 140, height: 18, radius: 8),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ShimmerBox(width: double.infinity, height: 280, radius: 24),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _ShimmerBox(width: 140, height: 18, radius: 8),
            ),
            const SizedBox(height: 14),
            ...List.generate(3, (_) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              child: _ShimmerBox(width: double.infinity, height: 120, radius: 20),
            )),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width, height, radius;
  const _ShimmerBox({required this.width, required this.height, required this.radius});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == double.infinity ? null : width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
