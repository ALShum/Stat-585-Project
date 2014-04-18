source('../Data Sets/age.R')

# Add total
agesex = ddply(agesex, .(state), transform,
               state_total = sum(freq))

# Pyramid Plot default (all states)
ggplot(data = agesex, aes(x = age, y = freq, fill=gender)) +
  coord_flip() + geom_bar(subset = .(gender=="Female"), stat="identity") +
  geom_bar(subset = .(gender=="Male"), stat="identity", aes(y=-freq))

# Pyramid plot filter by state
ggplot(data = subset(agesex, state=="Washington"), aes(x = age, y = freq, fill=gender)) +
  coord_flip() + geom_bar(subset = .(gender=="Female"), stat="identity") +
  geom_bar(subset = .(gender=="Male"), stat="identity", aes(y=-freq))



