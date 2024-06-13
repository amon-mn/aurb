import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final String urlImage;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const ProfilePic({
    Key? key,
    required this.urlImage,
    required this.width,
    required this.height,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: urlImage.startsWith('http')
                ? NetworkImage(urlImage)
                : AssetImage(urlImage) as ImageProvider,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 36,
              width: 36,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: onPressed,
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
