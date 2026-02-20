import torch
import torchvision.models as models

# Завантажуємо pretrained MobileNetV2
model = models.mobilenet_v2(weights=models.MobileNet_V2_Weights.DEFAULT)
model.eval()

# Dummy input
dummy = torch.rand(1, 3, 224, 224)

# TorchScript
traced_model = torch.jit.trace(model, dummy)

# Збереження
traced_model.save("model.pt")

print("✅ Model exported to model.pt")