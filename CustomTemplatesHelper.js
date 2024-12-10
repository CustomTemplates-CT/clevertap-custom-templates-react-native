import {NativeModules} from 'react-native';

const {CustomTemplatesModule} = NativeModules;

const CustomTemplatesHelper = {
  showCoachMarks: (jsonString, onComplete) => {
    CustomTemplatesModule.showCoachMarks(jsonString, onComplete);
  },

  showTooltips: (jsonString, onComplete) => {
    CustomTemplatesModule.showTooltips(jsonString, onComplete);
  },

  showSpotlights: (jsonString, onComplete) => {
    CustomTemplatesModule.showSpotlights(jsonString, onComplete);
  },
};

export default CustomTemplatesHelper;
