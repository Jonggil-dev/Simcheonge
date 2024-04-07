import asyncio, re
import torch, os, gc
from transformers import AutoTokenizer, AutoModelForCausalLM, set_seed

model = None
tokenizer = None

async def setCuda():
    os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"
    os.environ["CUDA_VISIBLE_DEVICES"] = "2"
    
    gc.collect()
    torch.cuda.empty_cache()

async def initModel():
    global model, tokenizer

    if model != None:
        return

    load_directory = "./saveModel"

    tokenizer = await getTokenizer(load_directory)
    model = await getLLModel(load_directory)

    token_list = ["[INST]", "[/INST]"]
    special_tokens_dict = {'bos_token': '<s>', 'eos_token': '</s>', 'pad_token': '[PAD]'}
    num_added_toks = tokenizer.add_tokens(token_list)
    tokenizer.add_special_tokens(special_tokens_dict)
    
    model.resize_token_embeddings(len(tokenizer))

    await setCuda()

async def promptModel(sentence: str):
    set_seed(0)
    pattern = r"\[INST\].*?\[/INST\]"
    
    input_text = f"<s> [INST] {sentence} [/INST]"    
    input_ids = tokenizer.encode(input_text, return_tensors="pt")
    
    max_length = 400
    sample_outputs = model.generate(
        input_ids=input_ids, 
        do_sample=True, 
        max_length=max_length, 
        temperature=0.7, 
        repetition_penalty=1.11)

    result = tokenizer.decode(sample_outputs[0], skip_special_tokens=True)
    print(result)
    result = re.sub(pattern, "", result).strip()
    return result

async def getTokenizer(path):
    print("getTokenizer")
    loop = asyncio.get_event_loop()

    return await loop.run_in_executor(None, loadTokenizer, path)

async def getLLModel(path):
    print("getLLModel")
    loop = asyncio.get_event_loop()
    return await loop.run_in_executor(None, loadLLModel, path)

def loadTokenizer(path):
    if os.path.exists(path) and os.path.isdir(path):
        return AutoTokenizer.from_pretrained(path)
    else:
        return None

def loadLLModel(path):
    if os.path.exists(path) and os.path.isdir(path):
        return AutoModelForCausalLM.from_pretrained(path)
    else:
        return None

