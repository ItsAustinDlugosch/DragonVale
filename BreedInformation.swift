class BreedInformation {
    let breedRequirements : [BreedRequirement]
    let breedTime : String
    let breedPercentage : BreedPercentage
    let cloneNormalPercentage : BreedPercentage
    let cloneSocialPercentage : BreedPercentage    
    let cloneRiftPercentage : BreedPercentage

    init(breedRequirements: [BreedRequirement], breedTime: String, breedPercentage: BreedPercentage,
         cloneSocialPercentage: BreedPercentage, cloneNormalPercentage: BreedPercentage, cloneRiftPercentage: BreedPercentage) {
        self.breedRequirements = breedRequirements
        self.breedTime = breedTime
        self.breedPercentage = breedPercentage
        self.cloneSocialPercentage = cloneSocialPercentage
        self.cloneNormalPercentage = cloneNormalPercentage
        self.cloneRiftPercentage = cloneRiftPercentage       
    }

   convenience init?(fields: [String]) {              
       let requirements = fields[0].separate(at: "+")
       var breedRequirements : [BreedRequirement] {
           var breedRequirements = [BreedRequirement]()
           for requirement in requirements {
               if let breedRequirement = BreedRequirement(requirement) {
                   breedRequirements.append(breedRequirement)
               }
           }
           return breedRequirements
       }

        if let breedPercentage = BreedPercentage(fields[2]),           
           let cloneSocialPercentage = BreedPercentage(fields[3]),              
           let cloneNormalPercentage = BreedPercentage(fields[4]),
           let cloneRiftPercentage =  BreedPercentage(fields[5]) {
        
            self.init(breedRequirements: breedRequirements, breedTime: fields[1], breedPercentage: breedPercentage,
                      cloneSocialPercentage: cloneSocialPercentage,
                      cloneNormalPercentage: cloneNormalPercentage,
                      cloneRiftPercentage: cloneRiftPercentage)
            
            
        } else {
            print("Failed Breed Information")
            return nil
        }
   }
}
