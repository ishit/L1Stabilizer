# Video Stabilization

Implementation of "Auto-Directed Video Stabilization with Robust L1 Optimal Camera Paths"([link](http://ieeexplore.ieee.org/document/5995525/)). The algorithm computes L1-norm optimized camera paths composed of constant, linear and parabolic segments inspired from professional camera equipment like tripods and camera dolly. The algorithm is evidently laden with significance for it's implementation in several modern video editors and YouTube. 

![Output sample](https://raw.githubusercontent.com/ishit/L1Stabilizer/master/stable.gif)

### Prerequisites


```
ffmpeg
matlab
cvx
vlfeat
```

### How-To

1. Extract frames to a directory.


```
    ffmpeg -i test.mp4 frames/out-%05d.jpg
```

2. Change vlfeat and cvx directory paths in `main.m` and `optimizeAffineTransforms.m`.
3. Change original and output directory for frames in `main.m`.
4. Run `main.m`.
5. Merge frames.
```
    bash create_video.sh
```

### Plots
![alt-text-1](https://raw.githubusercontent.com/ishit/L1Stabilizer/master/plots/motion_x.png "Motion in X") ![alt-text-2](https://raw.githubusercontent.com/ishit/L1Stabilizer/master/plots/motion_y.png "Motion in Y")

## To-Do

- [ ] Wobble suppression
- [ ] Mitigate rolling shutter troubles
- [ ] Video retargeting
- [ ] Saliency tracker(eg. face)

## License

This project is licensed under the GPL v.2 License.

