import tensorflow as tf
import numpy as np

# Chemin vers le modèle GPT-2 TensorFlow Lite
MODEL_PATH = 'chemin/vers/votre/modele.tflite'

# Charger le modèle TensorFlow Lite
interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Fonction pour générer du texte
def generate_text(prompt):
    input_data = np.array(prompt, dtype=np.int32)[np.newaxis, :]
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])
    return output_data

# Exemple d'utilisation
prompt = "Once upon a time"
generated_text = generate_text(prompt)
print(generated_text)
