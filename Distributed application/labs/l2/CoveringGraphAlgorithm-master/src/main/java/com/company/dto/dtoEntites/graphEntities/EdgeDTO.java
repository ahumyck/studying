package com.company.dto.dtoEntites.graphEntities;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EdgeDTO
{
    private String source;
    private String target;
    private String color;
}
