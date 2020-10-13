package com.company.dto.dtoEntites.graphEntities;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EdgeDataDTO {
    @JsonSerialize
    @JsonProperty("data")
    private EdgeDTO edgeDTO;
}
