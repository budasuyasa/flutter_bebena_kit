import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bebena_kit/flutter_bebena.dart';

class CustomCacheImage extends StatelessWidget {

  CustomCacheImage(this.urlImage, {
    this.borderRadius,
    this.size,
    this.aspectRatio,
    this.customBorderRadius,
    this.fit,
    this.withRoundedImage = false
  });

  final String urlImage;

  final double aspectRatio;

  /// Border radius for all edges
  final double borderRadius;

  /// Custom border
  final BorderRadius customBorderRadius;
  final Size size;
  final BoxFit fit;

  final bool withRoundedImage;

  @override
  Widget build(BuildContext context) {
    assert((size != null || aspectRatio != null), "Aspect Ratio atau Size tidak boleh kosong");

    
    Widget image = Container();
    if (size != null) {
      image = CachedNetworkImage(
        imageUrl    : urlImage,
        width       : size.width,
        height      : size.height,
        fit         : BoxFit.cover,
        errorWidget: (context, url, error) {
          return Label("Tidak dapat mengambil gambar");
        },
      );
    }

    if (aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: aspectRatio,
        child: CachedNetworkImage(
          imageUrl    : urlImage,
          fit         : fit ?? BoxFit.cover,
          errorWidget: (context, url, error) {
            return Center(child: Label("Tidak dapat mengambil gambar"));
          },
        ),
      );
    }

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: image,
      );
    }

    if (customBorderRadius != null) {
      image = ClipRRect(
        borderRadius: customBorderRadius,
        child: image,
      );
    }

    if (withRoundedImage) {
      image = ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(size.width / 2)),
        child: image,
      );
    }

    return image;
  }
}