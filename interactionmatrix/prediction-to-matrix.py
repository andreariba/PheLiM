import pandas as pd
import sys

if len(sys.argv) < 3:
    sys.exit('Usage: %s <off prediction file> <on prediction file>' % sys.argv[0])

df1 = pd.read_table(sys.argv[1], names=["gene", "siRNA", "score"])

df2 = pd.read_table(sys.argv[2], names=["gene", "siRNA", "score"])

frame = [ df1, df2 ]
df = pd.concat(frame)
df = df.pivot_table(index="siRNA", values="score", columns="gene", aggfunc=sum)
df = df.fillna(0.0)
df.to_csv("output_pivoted.tab", sep="\t")

