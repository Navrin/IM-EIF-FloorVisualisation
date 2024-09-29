
/**
 TODO[MAYBE]: Support legacy values? (pre-2021)
 Question: Should all sensors be defined by In and Out values, or should
 In/Out be a parameter for the toAPIFormat function?
 */
public enum LegacySensor {
  PC00_05_IN, PC00_05_OUT, PC00_06_IN, PC00_06_OUT, PC00_07_IN,
    PC00_07_OUT, PC00_08_IN, PC00_08_OUT, PC00_09_IN, PC00_09_OUT,
    PC01_11_IN, PC01_11_OUT, PC01_12_IN, PC01_12_OUT, PC01_13_IN,
    PC01_13_OUT, PC02_14_IN, PC02_14_OUT, PC02_15_IN, PC02_15_OUT,
    PC02_16_IN, PC02_16_OUT, PC03_17_IN, PC03_17_OUT, PC04_20_IN,
    PC04_20_OUT, PC05_21_IN, PC05_21_OUT, PC05_22_IN, PC05_22_OUT,
    PC05_23_IN, PC05_23_OUT, PC05_24_IN, PC05_24_OUT, PC08_25_IN,
    PC08_25_OUT, PC09_26_IN, PC09_26_OUT, PC09_27_IN, PC09_27_OUT,
    PC09_28_IN, PC09_28_OUT, PC09_29_IN, PC09_29_OUT, PC10_30_IN,
    PC10_30_OUT, PC11_31_IN, PC11_31_OUT, PC11_32_IN, PC11_32_OUT,
    PC11_33_IN, PC11_33_OUT, PCB1_01_IN, PCB1_01_OUT, PCB1_02_IN,
    PCB1_02_OUT, PCB1_03_IN, PCB1_03_OUT, PCB1_04_IN, PCB1_04_OUT;

  public String toAPIFormat() {
    switch (this) {
    case PC00_05_IN:
      return "PC00.05 (In)";
    case PC00_05_OUT:
      return "PC00.05 (Out)";
    case PC00_06_IN:
      return "PC00.06 (In)";
    case PC00_06_OUT:
      return "PC00.06 (Out)";
    case PC00_07_IN:
      return "PC00.07 (In)";
    case PC00_07_OUT:
      return "PC00.07 (Out)";
    case PC00_08_IN:
      return "PC00.08 (In)";
    case PC00_08_OUT:
      return "PC00.08 (Out)";
    case PC00_09_IN:
      return "PC00.09 (In)";
    case PC00_09_OUT:
      return "PC00.09 (Out)";
    case PC01_11_IN:
      return "PC01.11 (In)";
    case PC01_11_OUT:
      return "PC01.11 (Out)";
    case PC01_12_IN:
      return "PC01.12 (In)";
    case PC01_12_OUT:
      return "PC01.12 (Out)";
    case PC01_13_IN:
      return "PC01.13 (In)";
    case PC01_13_OUT:
      return "PC01.13 (Out)";
    case PC02_14_IN:
      return "PC02.14 (In)";
    case PC02_14_OUT:
      return "PC02.14 (Out)";
    case PC02_15_IN:
      return "PC02.15 (In)";
    case PC02_15_OUT:
      return "PC02.15 (Out)";
    case PC02_16_IN:
      return "PC02.16 (In)";
    case PC02_16_OUT:
      return "PC02.16 (Out)";
    case PC03_17_IN:
      return "PC03.17 (In)";
    case PC03_17_OUT:
      return "PC03.17 (Out)";
    case PC04_20_IN:
      return "PC04.20 (In)";
    case PC04_20_OUT:
      return "PC04.20 (Out)";
    case PC05_21_IN:
      return "PC05.21 (In)";
    case PC05_21_OUT:
      return "PC05.21 (Out)";
    case PC05_22_IN:
      return "PC05.22 (In)";
    case PC05_22_OUT:
      return "PC05.22 (Out)";
    case PC05_23_IN:
      return "PC05.23 (In)";
    case PC05_23_OUT:
      return "PC05.23 (Out)";
    case PC05_24_IN:
      return "PC05.24 (In)";
    case PC05_24_OUT:
      return "PC05.24 (Out)";
    case PC08_25_IN:
      return "PC08.25 (In)";
    case PC08_25_OUT:
      return "PC08.25 (Out)";
    case PC09_26_IN:
      return "PC09.26 (In)";
    case PC09_26_OUT:
      return "PC09.26 (Out)";
    case PC09_27_IN:
      return "PC09.27 (In)";
    case PC09_27_OUT:
      return "PC09.27 (Out)";
    case PC09_28_IN:
      return "PC09.28 (In)";
    case PC09_28_OUT:
      return "PC09.28 (Out)";
    case PC09_29_IN:
      return "PC09.29 (In)";
    case PC09_29_OUT:
      return "PC09.29 (Out)";
    case PC10_30_IN:
      return "PC10.30 (In)";
    case PC10_30_OUT:
      return "PC10.30 (Out)";
    case PC11_31_IN:
      return "PC11.31 (In)";
    case PC11_31_OUT:
      return "PC11.31 (Out)";
    case PC11_32_IN:
      return "PC11.32 (In)";
    case PC11_32_OUT:
      return "PC11.32 (Out)";
    case PC11_33_IN:
      return "PC11.33 (In)";
    case PC11_33_OUT:
      return "PC11.33 (Out)";
    case PCB1_01_IN:
      return "PCB1.01 (In)";
    case PCB1_01_OUT:
      return "PCB1.01 (Out)";
    case PCB1_02_IN:
      return "PCB1.02 (In)";
    case PCB1_02_OUT:
      return "PCB1.02 (Out)";
    case PCB1_03_IN:
      return "PCB1.03 (In)";
    case PCB1_03_OUT:
      return "PCB1.03 (Out)";
    case PCB1_04_IN:
      return "PCB1.04 (In)";
    case PCB1_04_OUT:
      return "PCB1.04 (Out)";
    default:
      throw new UnsupportedOperationException("API format not given for enum member "+this);
    }
  }


  /**
   * !!TODO!!
   * This function should return the coordinate for the given sensor for the scene.
   * The coordinate should be correct for the scene within the 3D view.
   *
   * Q: how will this work with the In/Out definition?
   */
  public Vector toMapPosition() {
    throw new UnsupportedOperationException("Not implemented yet");
  }
}
