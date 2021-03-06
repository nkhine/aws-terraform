s3: init_s3
	@cd $(BUILD)/$@; $(SCRIPTS)/tf-apply-confirm.sh
	@$(MAKE) gen_s3_vars

plan_s3: init_s3
	cd $(BUILD)/s3; $(TF_GET); $(TF_PLAN)

destroy_s3:  
	cd $(BUILD)/s3; $(TF_DESTROY)

show_s3:  
	cd $(BUILD)/s3; $(TF_SHOW) 

init_s3: init
	mkdir -p $(BUILD)/s3
	rsync -av  $(RESOURCES)/terraforms/s3/ $(BUILD)/s3
	ln -sf $(BUILD)/*.tf $(BUILD)/s3

clean_s3:
	rm -rf $(BUILD)/s3

gen_s3_vars:
	cd $(BUILD)/s3; ${SCRIPTS}/gen-tf-vars.sh > $(BUILD)/s3_vars.tf

.PHONY: s3 plan_destroy_s3 destroy_s3 plan_s3 init_s3 gen_s3_vars clean_s3

