from PIL import Image

# Define the input image path and the destination save path
input_image_path = "./densepose.0001.jpg"
new_image_path = "./HR-VITON/test/test/image-densepose/00001_00.jpg"

def copy_image(input_path, output_path):
    """
    Open an image from the input path and save it to the output path.

    Parameters:
    - input_path (str): The path to the input image file.
    - output_path (str): The destination path where the image will be saved.
    """
    # Open the image
    img = Image.open(input_path)
    
    # Save the image to the new path
    img.save(output_path)
    print(f"Image saved at {output_path}")

# Run the function with the specified paths
copy_image(input_image_path, new_image_path)
