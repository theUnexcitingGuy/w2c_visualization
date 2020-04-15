import pandas as pd
import numpy as np 
from sklearn.decomposition import PCA
from matplotlib import pyplot
from gensim.models import Word2Vec
from sklearn.manifold import TSNE
import plotly.express as px

def create_3d_df(text, count):
	sentences = text.split('.')
	sentences_final = []
	for sen in sentences:
		tokens = sen.split()
		sentences_final.append(tokens)
	our_model = Word2Vec(sentences_final, min_count=count)
	# summarize vocabulary
	words = list(our_model.wv.vocab)
	X = our_model[our_model.wv.vocab]
	tsne = TSNE(n_components=3)
	X_tsne = tsne.fit_transform(X)
	df = pd.DataFrame(X_tsne, index = words,columns=['x', 'y', 'z'])
	return df

def similar_words(text, count, word):
	sentences = text.split('.')
	sentences_final = []
	for sen in sentences:
		tokens = sen.split()
		sentences_final.append(tokens)
	our_model = Word2Vec(sentences_final, min_count=count)
	lista = our_model.most_similar(positive= word)
	similar_words = []
	for element in lista:
		similar_words.append(element[0])
	similar_words.append(word)
	return similar_words

def scatter_plot(text, count):
	sentences = text.split('.')
	sentences_final = []
	for sen in sentences:
		tokens = sen.split()
		sentences_final.append(tokens)
	our_model = Word2Vec(sentences_final, min_count=count)
	# summarize vocabulary
	words = list(our_model.wv.vocab)
	X = our_model[our_model.wv.vocab]
	tsne = TSNE(n_components=3)
	X_tsne = tsne.fit_transform(X)
	df = pd.DataFrame(X_tsne, index = words,columns=['x', 'y', 'z'])
	fig = px.scatter_3d(df, x='x', y='y', z='z', text = df.index, template='plotly_white')
	fig.show()