function in_use=label_in_use(self,label_test)

labels={self.model.roi.label};
in_use=any(strcmp(label_test,labels));

end
