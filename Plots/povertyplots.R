source('../Data Sets/poverty.R')


# Plot percentage below by state on state map
pov = ddply(pov, .(state), transform,
            state_total = sum(freq))
povstate = ddply(pov, .(state,level), summarise,
                 total = sum(freq),
                 state_total = state_total)

# Plot percentage below by state and household
pov = ddply(pov, .(state,household), transform,
            state_total = sum(freq))
povhouse = ddply(pov, .(state, household, level), summarise, 
                 freq = sum(freq),
                 state_total = state_total)

# Plot percentage below by state and education
pov = ddply(pov, .(state,education), transform,
            state_total = sum(freq))
poved = ddply(pov, .(state, education, level), summarise, 
              freq = sum(freq),
              state_total = state_total)

