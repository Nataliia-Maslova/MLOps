import torch
from torchvision import transforms
from PIL import Image
import sys

model = torch.jit.load("model.pt")
model.eval()

transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor()
])

def predict(image_path):
    image = Image.open(image_path).convert("RGB")
    tensor = transform(image).unsqueeze(0)

    with torch.no_grad():
        output = model(tensor)
        probs = torch.nn.functional.softmax(output[0], dim=0)
        top3 = torch.topk(probs, 3)

    print("🧠 Top-3 predictions:")
    for idx, score in zip(top3.indices, top3.values):
        print(f"Class ID: {idx.item()}, Confidence: {score.item():.4f}")

if __name__ == "__main__":
    predict(sys.argv[1])