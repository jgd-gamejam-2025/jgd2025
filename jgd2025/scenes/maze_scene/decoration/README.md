# 装饰方块说明

这些白色发光方块用于装饰数字世界场景，无碰撞体，纯装饰用途。

## 方块类型

### 1. FloatingCube（浮动方块）
- **效果**：上下浮动 + 旋转
- **特点**：最基础的装饰方块，适合大量使用
- **参数**：
  - `float_amplitude`: 浮动幅度（默认 0.5）
  - `float_speed`: 浮动速度（默认 1.0）
  - `rotation_speed`: 旋转速度（默认 Y轴 45度/秒）
  - `cube_size`: 方块大小（默认 1.0）
  - `emission_strength`: 发光强度（默认 2.0）

### 2. PulsingCube（脉冲方块）
- **效果**：大小变化 + 浮动 + 旋转
- **特点**：呼吸感强，适合作为视觉焦点
- **参数**：
  - `pulse_min_scale`: 最小缩放（默认 0.8）
  - `pulse_max_scale`: 最大缩放（默认 1.2）
  - `pulse_speed`: 脉冲速度（默认 2.0）
  - `float_amplitude`: 浮动幅度（默认 0.3）
  - `emission_strength`: 发光强度（默认 2.5）

### 3. OrbitingCube（轨道方块）
- **效果**：围绕中心点旋转 + 自转
- **特点**：需要设置轨道中心，适合作为环绕装饰
- **参数**：
  - `orbit_radius`: 轨道半径（默认 2.0）
  - `orbit_speed`: 轨道速度（默认 1.0）
  - `orbit_axis`: 轨道轴（默认 Y轴）
  - `cube_rotation_speed`: 自转速度（默认 Y轴 90度/秒）

### 4. GlitchCube（故障方块）
- **效果**：随机位置跳动 + 闪烁 + 浮动 + 旋转
- **特点**：数字世界风格，故障美学
- **参数**：
  - `glitch_intensity`: 故障强度（默认 0.1）
  - `glitch_frequency`: 故障频率（默认 0.2次/秒）
  - `blink_enabled`: 是否闪烁（默认 true）
  - `emission_strength`: 发光强度（默认 3.0）

## 使用方法

1. 在场景编辑器中添加装饰方块场景
2. 调整位置到空中适当位置
3. 根据需要调整参数（大小、速度、发光强度等）
4. 方块会自动开始动画，无需额外设置

## 布置建议

- **密集区域**：使用 FloatingCube，数量多但不抢眼
- **关键位置**：使用 PulsingCube 或 GlitchCube，吸引注意力
- **环绕装饰**：使用 OrbitingCube 围绕重要物体
- **混搭使用**：不同类型混合使用，增加视觉层次

## 注意事项

- 所有方块都**没有碰撞体**，玩家可以穿过
- `random_offset` 参数确保多个方块不会同步运动
- 可以通过调整 `emission_strength` 控制方块亮度
- 建议在暗色调场景中使用，白色发光效果更明显
